import Foundation
import UIKit
import GoogleMobileAds

/// Base implementation của IShowBehavior.
/// Xử lý logic cơ bản: load layout, populate ad view, và hiển thị.
/// Tương đương với BaseShowBehavior.kt
@objc public class BaseShowBehavior: NSObject, IShowBehavior {
    
    private(set) var rootView: UIView?
    private weak var viewControllerRef: UIViewController?
    private weak var nativeAdView: GADNativeAdView?
    
    // MARK: - IShowBehavior Implementation
    
    public func show(viewController: UIViewController,
                     nativeAd: GADNativeAd,
                     layoutName: String,
                     callbacks: NativeAdCallbacks) {
        self.viewControllerRef = viewController
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Tạo container view với pass-through hit testing
            let adContainer = PassthroughView()
            adContainer.translatesAutoresizingMaskIntoConstraints = false
            self.rootView = adContainer
            
            viewController.view.addSubview(adContainer)
            
            // ✅ Constraint: căn giữa container trong view controller
            NSLayoutConstraint.activate([
                adContainer.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                adContainer.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                adContainer.widthAnchor.constraint(equalToConstant: viewController.view.frame.width),
                adContainer.heightAnchor.constraint(equalToConstant: viewController.view.frame.height)
            ])
            
            adContainer.backgroundColor = .clear // tránh màu nền che nội dung
            
            // 2. Load layout từ .xib
            guard let adContentView = self.loadLayout(named: layoutName, in: adContainer) else {
                print("❌ BaseShowBehavior: Failed to load layout '\(layoutName)'")
                self.rootView?.removeFromSuperview()
                self.rootView = nil
                return
            }
            
            // 3. Tìm GADNativeAdView trong layout
            guard let nativeAdView = self.findNativeAdView(in: adContentView) else {
                print("❌ BaseShowBehavior: GADNativeAdView not found in layout '\(layoutName)'")
                self.rootView?.removeFromSuperview()
                self.rootView = nil
                return
            }
            
            // Store reference for cleanup
            self.nativeAdView = nativeAdView
            
            // 3.5. Set ad view reference cho pass-through hit testing
            adContainer.adView = nativeAdView
            
            // 4. Populate ad view với data
            self.populateNativeAdView(nativeAd, into: nativeAdView)
            
            // 5. Add content view vào container
            adContainer.addSubview(adContentView)
            adContentView.translatesAutoresizingMaskIntoConstraints = false
            
            // ✅ Constraint: fill content trong container
            NSLayoutConstraint.activate([
                adContentView.topAnchor.constraint(equalTo: adContainer.topAnchor),
                adContentView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
                adContentView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
                adContentView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor)
            ])
            
            print("✅ BaseShowBehavior: Ad view displayed and centered successfully")
        }
    }

    
    public func destroy() {
        // Capture rootView reference before clearing
        let viewToRemove = self.rootView
        
        // Clear references immediately (synchronous)
        self.rootView = nil
        self.nativeAdView = nil
        
        // Perform UI cleanup on main thread
        DispatchQueue.main.async {
            guard let viewToRemove = viewToRemove else { return }
            
            // 1. Hide immediately for better UX
            viewToRemove.isHidden = true
            viewToRemove.alpha = 0
            
            // 2. Clear PassthroughView reference
            if let passthroughView = viewToRemove as? PassthroughView {
                passthroughView.adView = nil
            }
            
            // 3. Find and clear GADNativeAdView
            if let adView = self.findNativeAdViewRecursive(in: viewToRemove) {
                adView.nativeAd = nil
                adView.mediaView = nil
                adView.headlineView = nil
                adView.bodyView = nil
                adView.callToActionView = nil
                adView.iconView = nil
                adView.starRatingView = nil
                adView.advertiserView = nil
                adView.storeView = nil
                adView.priceView = nil
            }
            
            // 4. Deactivate all constraints
            NSLayoutConstraint.deactivate(viewToRemove.constraints)
            if let superview = viewToRemove.superview {
                let relatedConstraints = superview.constraints.filter { constraint in
                    constraint.firstItem as? UIView == viewToRemove || 
                    constraint.secondItem as? UIView == viewToRemove
                }
                NSLayoutConstraint.deactivate(relatedConstraints)
            }
            
            // 5. Remove all subviews recursively
            self.removeAllSubviewsRecursively(from: viewToRemove)
            
            // 6. Remove from superview
            viewToRemove.removeFromSuperview()
            
            print("✅ BaseShowBehavior: Ad view destroyed")
        }
    }
    
    /// Helper: Find GADNativeAdView recursively
    private func findNativeAdViewRecursive(in view: UIView) -> GADNativeAdView? {
        if let adView = view as? GADNativeAdView {
            return adView
        }
        
        for subview in view.subviews {
            if let found = findNativeAdViewRecursive(in: subview) {
                return found
            }
        }
        
        return nil
    }
    
    /// Helper: Remove all subviews recursively
    private func removeAllSubviewsRecursively(from view: UIView) {
        for subview in view.subviews {
            removeAllSubviewsRecursively(from: subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Public Accessors
    
    /// Trả về root view để decorators có thể truy cập
    public func getRootView() -> UIView? {
        return rootView
    }
    
    // MARK: - Private Helpers
    
    /// Load .xib file và trả về root view
    private func loadLayout(named name: String, in container: UIView) -> UIView? {
        // 1. Thử load từ framework bundle (nơi .xib nằm)
        // Tìm bundle chứa class BaseShowBehavior (framework bundle)
        let frameworkBundle = Bundle(for: type(of: self))
        if let views = frameworkBundle.loadNibNamed(name, owner: nil, options: nil),
           let view = views.first as? UIView {
            print("✅ Loaded .xib '\(name)' from framework bundle")
            return view
        }
        
        // 2. Fallback: Thử load từ main bundle
        if let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil),
           let view = views.first as? UIView {
            print("✅ Loaded .xib '\(name)' from main bundle")
            return view
        }
        
        // 3. Last resort: thử tìm trong tất cả các bundle
        for bundle in Bundle.allBundles {
            if let views = bundle.loadNibNamed(name, owner: nil, options: nil),
               let view = views.first as? UIView {
                print("✅ Loaded .xib '\(name)' from bundle: \(bundle.bundlePath)")
                return view
            }
        }
        
        print("❌ Could not find .xib '\(name)' in any bundle")
        return nil
    }
    
    /// Tìm GADNativeAdView trong view hierarchy
    private func findNativeAdView(in view: UIView) -> GADNativeAdView? {
        if let nativeAdView = view as? GADNativeAdView {
            return nativeAdView
        }
        
        for subview in view.subviews {
            if let found = findNativeAdView(in: subview) {
                return found
            }
        }
        
        return nil
    }
    
    /// Populate GADNativeAdView với data từ GADNativeAd
    /// Sử dụng Tag system (101-112) để bind views
    private func populateNativeAdView(_ nativeAd: GADNativeAd, into adView: GADNativeAdView) {
        // Tag constants (theo bảng quy ước)
        let TAG_HEADLINE = 101
        let TAG_BODY = 102
        let TAG_MEDIA_VIEW = 103
        let TAG_ICON = 104
        let TAG_CTA = 105
        let TAG_RATING = 106
        let TAG_ADVERTISER = 107
        let TAG_STORE = 108
        let TAG_PRICE = 109
        
        // 1. Media View (required)
        if let mediaView = adView.viewWithTag(TAG_MEDIA_VIEW) as? GADMediaView {
            mediaView.isUserInteractionEnabled = true  // MUST be enabled for media interaction
            adView.mediaView = mediaView
        }
        
        // 2. Headline
        if let headlineLabel = adView.viewWithTag(TAG_HEADLINE) as? UILabel {
            headlineLabel.text = nativeAd.headline
            headlineLabel.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.headlineView = headlineLabel
        }
        
        // 3. Body
        if let bodyLabel = adView.viewWithTag(TAG_BODY) as? UILabel {
            bodyLabel.text = nativeAd.body
            bodyLabel.isHidden = nativeAd.body == nil
            bodyLabel.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.bodyView = bodyLabel
        }
        
        // 4. Call to Action
        if let ctaButton = adView.viewWithTag(TAG_CTA) as? UIButton {
            ctaButton.setTitle(nativeAd.callToAction, for: .normal)
            ctaButton.isHidden = nativeAd.callToAction == nil
            ctaButton.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.callToActionView = ctaButton
        }
        
        // 5. Icon
        if let iconImageView = adView.viewWithTag(TAG_ICON) as? UIImageView {
            iconImageView.image = nativeAd.icon?.image
            iconImageView.isHidden = nativeAd.icon == nil
            iconImageView.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.iconView = iconImageView
        }
        
        // 6. Star Rating (iOS không có RatingBar, dùng UIImageView hoặc custom view)
        if let ratingView = adView.viewWithTag(TAG_RATING) {
            if let rating = nativeAd.starRating {
                // TODO: Có thể render rating stars ở đây
                ratingView.isHidden = false
            } else {
                ratingView.isHidden = true
            }
            ratingView.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.starRatingView = ratingView
        }
        
        // 7. Advertiser
        if let advertiserLabel = adView.viewWithTag(TAG_ADVERTISER) as? UILabel {
            advertiserLabel.text = nativeAd.advertiser
            advertiserLabel.isHidden = nativeAd.advertiser == nil
            advertiserLabel.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.advertiserView = advertiserLabel
        }
        
        // 8. Store
        if let storeLabel = adView.viewWithTag(TAG_STORE) as? UILabel {
            storeLabel.text = nativeAd.store
            storeLabel.isHidden = nativeAd.store == nil
            storeLabel.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.storeView = storeLabel
        }
        
        // 9. Price
        if let priceLabel = adView.viewWithTag(TAG_PRICE) as? UILabel {
            priceLabel.text = nativeAd.price
            priceLabel.isHidden = nativeAd.price == nil
            priceLabel.isUserInteractionEnabled = false  // CRITICAL: Disable interaction
            adView.priceView = priceLabel
        }
        
        // IMPORTANT: Set native ad vào ad view
        adView.nativeAd = nativeAd
        
        print("✅ BaseShowBehavior: Ad view populated successfully")
    }
}
