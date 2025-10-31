import Foundation
import UIKit
import GoogleMobileAds

/// Base implementation of IShowBehavior
/// Handles basic logic: load layout, populate ad view, and display
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
            
            let adContainer = PassthroughView()
            adContainer.translatesAutoresizingMaskIntoConstraints = false
            self.rootView = adContainer
            
            viewController.view.addSubview(adContainer)
            
            NSLayoutConstraint.activate([
                adContainer.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
                adContainer.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
                adContainer.widthAnchor.constraint(equalToConstant: viewController.view.frame.width),
                adContainer.heightAnchor.constraint(equalToConstant: viewController.view.frame.height)
            ])
            
            adContainer.backgroundColor = .clear
            
            guard let adContentView = self.loadLayout(named: layoutName, in: adContainer) else {
                self.rootView?.removeFromSuperview()
                self.rootView = nil
                return
            }
            
            guard let nativeAdView = self.findNativeAdView(in: adContentView) else {
                self.rootView?.removeFromSuperview()
                self.rootView = nil
                return
            }
            
            self.nativeAdView = nativeAdView
            adContainer.adView = nativeAdView
            
            self.populateNativeAdView(nativeAd, into: nativeAdView)
            
            adContainer.addSubview(adContentView)
            adContentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                adContentView.topAnchor.constraint(equalTo: adContainer.topAnchor),
                adContentView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
                adContentView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
                adContentView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor)
            ])
        }
    }

    
    public func destroy() {
        let viewToRemove = self.rootView
        
        // Clear references immediately (synchronous)
        self.rootView = nil
        self.nativeAdView = nil
        
        DispatchQueue.main.async {
            guard let viewToRemove = viewToRemove else { return }
            
            viewToRemove.isHidden = true
            viewToRemove.alpha = 0
            
            if let passthroughView = viewToRemove as? PassthroughView {
                passthroughView.adView = nil
            }
            
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
            
            NSLayoutConstraint.deactivate(viewToRemove.constraints)
            if let superview = viewToRemove.superview {
                let relatedConstraints = superview.constraints.filter { constraint in
                    constraint.firstItem as? UIView == viewToRemove || 
                    constraint.secondItem as? UIView == viewToRemove
                }
                NSLayoutConstraint.deactivate(relatedConstraints)
            }
            
            self.removeAllSubviewsRecursively(from: viewToRemove)
            viewToRemove.removeFromSuperview()
        }
    }
    
    // MARK: - Helper Methods
    
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
    
    private func removeAllSubviewsRecursively(from view: UIView) {
        for subview in view.subviews {
            removeAllSubviewsRecursively(from: subview)
            NSLayoutConstraint.deactivate(subview.constraints)
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Public Accessors
    
    public func getRootView() -> UIView? {
        return rootView
    }
    
    // MARK: - Private Helpers
    
    /// Load .xib file and return root view
    private func loadLayout(named name: String, in container: UIView) -> UIView? {
        let frameworkBundle = Bundle(for: type(of: self))
        if let views = frameworkBundle.loadNibNamed(name, owner: nil, options: nil),
           let view = views.first as? UIView {
            print("✅ Loaded .xib '\(name)' from framework bundle")
            return view
        }
        
        if let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil),
           let view = views.first as? UIView {
            print("✅ Loaded .xib '\(name)' from main bundle")
            return view
        }
        
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
    
    /// Populate GADNativeAdView with ad data using tag system (101-109)
    private func populateNativeAdView(_ nativeAd: GADNativeAd, into adView: GADNativeAdView) {
        let TAG_HEADLINE = 101
        let TAG_BODY = 102
        let TAG_MEDIA_VIEW = 103
        let TAG_ICON = 104
        let TAG_CTA = 105
        let TAG_RATING = 106
        let TAG_ADVERTISER = 107
        let TAG_STORE = 108
        let TAG_PRICE = 109
        
        if let mediaView = adView.viewWithTag(TAG_MEDIA_VIEW) as? GADMediaView {
            adView.mediaView = mediaView
        }
        
        if let headlineLabel = adView.viewWithTag(TAG_HEADLINE) as? UILabel {
            headlineLabel.text = nativeAd.headline
            adView.headlineView = headlineLabel
        }
        
        if let bodyLabel = adView.viewWithTag(TAG_BODY) as? UILabel {
            bodyLabel.text = nativeAd.body
            bodyLabel.isHidden = nativeAd.body == nil
            adView.bodyView = bodyLabel
        }
        
        if let ctaButton = adView.viewWithTag(TAG_CTA) as? UIButton {
            ctaButton.setTitle(nativeAd.callToAction, for: .normal)
            ctaButton.isHidden = nativeAd.callToAction == nil
            ctaButton.isUserInteractionEnabled = false
            adView.callToActionView = ctaButton
        }
        
        if let iconImageView = adView.viewWithTag(TAG_ICON) as? UIImageView {
            iconImageView.image = nativeAd.icon?.image
            iconImageView.isHidden = nativeAd.icon == nil
            adView.iconView = iconImageView
        }
        
        if let ratingView = adView.viewWithTag(TAG_RATING) {
            ratingView.isHidden = nativeAd.starRating == nil
            adView.starRatingView = ratingView
        }
        
        if let advertiserLabel = adView.viewWithTag(TAG_ADVERTISER) as? UILabel {
            advertiserLabel.text = nativeAd.advertiser
            advertiserLabel.isHidden = nativeAd.advertiser == nil
            adView.advertiserView = advertiserLabel
        }
        
        if let storeLabel = adView.viewWithTag(TAG_STORE) as? UILabel {
            storeLabel.text = nativeAd.store
            storeLabel.isHidden = nativeAd.store == nil
            adView.storeView = storeLabel
        }
        
        if let priceLabel = adView.viewWithTag(TAG_PRICE) as? UILabel {
            priceLabel.text = nativeAd.price
            priceLabel.isHidden = nativeAd.price == nil
            adView.priceView = priceLabel
        }
        
        adView.nativeAd = nativeAd
    }
}
