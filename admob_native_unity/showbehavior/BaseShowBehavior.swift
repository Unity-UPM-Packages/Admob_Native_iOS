import Foundation
import UIKit
import GoogleMobileAds

/// Base implementation của IShowBehavior.
/// Xử lý logic cơ bản: load layout, populate ad view, và hiển thị.
/// Tương đương với BaseShowBehavior.kt
@objc public class BaseShowBehavior: NSObject, IShowBehavior {
    
    private(set) var rootView: UIView?
    private weak var viewControllerRef: UIViewController?
    private weak var nativeAdView: GADNativeAdView?  // Keep reference for cleanup
    
    deinit {
        print("🗑️ BaseShowBehavior: deallocated from memory")
    }
    
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("🗑️ BaseShowBehavior: Starting destroy...")
            
            // 0. Hide view immediately để user không thấy
            self.rootView?.isHidden = true
            self.rootView?.alpha = 0
            print("  ✓ RootView hidden")
            
            // 1. Clear PassthroughView reference
            if let passthroughView = self.rootView as? PassthroughView {
                passthroughView.adView = nil
                print("  ✓ PassthroughView.adView cleared")
            }
            
            // 2. Cleanup GADNativeAdView trước
            if let adView = self.nativeAdView {
                // Clear native ad reference để stop tracking
                adView.nativeAd = nil
                
                // Clear all asset views
                adView.mediaView = nil
                adView.headlineView = nil
                adView.bodyView = nil
                adView.callToActionView = nil
                adView.iconView = nil
                adView.starRatingView = nil
                adView.advertiserView = nil
                adView.storeView = nil
                adView.priceView = nil
                
                print("  ✓ GADNativeAdView cleared")
            }
            
            // 3. Deactivate all constraints on rootView
            if let rootView = self.rootView {
                NSLayoutConstraint.deactivate(rootView.constraints)
                if let superview = rootView.superview {
                    let rootViewConstraints = superview.constraints.filter { constraint in
                        constraint.firstItem as? UIView == rootView || 
                        constraint.secondItem as? UIView == rootView
                    }
                    NSLayoutConstraint.deactivate(rootViewConstraints)
                }
                print("  ✓ Constraints deactivated")
            }
            
            // 4. Remove all subviews từ rootView (recursive)
            self.rootView?.subviews.forEach { subview in
                self.removeViewRecursively(subview)
            }
            print("  ✓ Subviews removed")
            
            // 5. Remove rootView từ parent
            if let rootView = self.rootView {
                let viewType = String(describing: type(of: rootView))
                let hasSuperview = rootView.superview != nil
                print("  → Removing rootView (type: \(viewType), hasSuperview: \(hasSuperview))")
                
                rootView.removeFromSuperview()
                
                let stillHasSuperview = rootView.superview != nil
                print("  ✓ RootView removed from superview (stillHasSuperview: \(stillHasSuperview))")
            }
            
            // 6. Clear references
            let rootViewType = self.rootView != nil ? String(describing: type(of: self.rootView!)) : "nil"
            print("  → Clearing references (rootView type before clear: \(rootViewType))")
            
            self.rootView = nil
            self.nativeAdView = nil
            
            print("  ✓ References cleared (rootView is now: \(self.rootView == nil ? "nil" : "NOT NIL!"))")
            print("✅ BaseShowBehavior: Ad view destroyed completely")
        }
    }
    
    /// Helper để remove view recursively
    private func removeViewRecursively(_ view: UIView) {
        // Remove tất cả subviews trước
        view.subviews.forEach { subview in
            removeViewRecursively(subview)
        }
        
        // Deactivate constraints của view này
        NSLayoutConstraint.deactivate(view.constraints)
        
        // Remove view
        view.removeFromSuperview()
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
