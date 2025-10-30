import UIKit
import GoogleMobileAds

/// Custom UIView that allows touch events to pass through to views below
/// when touch is outside of GADNativeAdView bounds.
/// 
/// This solves the problem where a full-screen transparent container
/// blocks all touches to Unity game UI underneath.
class PassthroughView: UIView {
    
    /// Reference to the GADNativeAdView that should receive touches
    weak var adView: GADNativeAdView?
    
    deinit {
        print("🗑️ PassthroughView: deallocated from memory")
    }
    
    /// Override hit testing to pass through touches outside ad view
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 1. Check if we have an ad view
        guard let adView = adView else {
            // No ad view, pass through all touches
            return nil
        }
        
        // 2. Convert point to ad view's coordinate system
        let pointInAdView = self.convert(point, to: adView)
        
        // 3. Check if touch is inside ad view bounds
        if adView.bounds.contains(pointInAdView) {
            // Touch is inside ad view, let default hit testing handle it
            return super.hitTest(point, with: event)
        }
        
        // 4. Touch is outside ad view, pass through
        return nil
    }
}
