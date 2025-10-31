import Foundation
import UIKit
import GoogleMobileAds

@objc public class AdmobNativeController: NSObject {
    
    private var loadedNativeAd: GADNativeAd?
    private var currentShowBehavior: IShowBehavior?
    private weak var viewController: UIViewController?
    private weak var callbacks: NativeAdCallbacks?
    
    private var adLoader: GADAdLoader?
    
    private var countdownConfig: (initial: Float, duration: Float, closeDelay: Float)?
    private var positionConfig: (x: Int, y: Int)?
    
    @objc public init(viewController: UIViewController, callbacks: NativeAdCallbacks) {
        self.viewController = viewController
        self.callbacks = callbacks
        super.init()
        print("✅ AdmobNativeController initialized")
    }
    
    @objc public func loadAd(adUnitId: String, request: GADRequest) {
        print("📡 AdmobNativeController: Loading ad for unit ID: \(adUnitId)")
        
        guard let viewController = viewController else {
            print("❌ View controller is nil")
            return
        }
        
        let videoOptions = GADVideoOptions()
        videoOptions.startMuted = true
        videoOptions.customControlsRequested = false
        videoOptions.clickToExpandRequested = false
        
        adLoader = GADAdLoader(
            adUnitID: adUnitId,
            rootViewController: viewController,
            adTypes: [.native],
            options: [videoOptions]
        )
        
        adLoader?.delegate = self
        
        adLoader?.load(request)
    }
    
    @objc public func showAd(layoutName: String) {
        print("📺 AdmobNativeController: Showing ad with layout: \(layoutName)")
        
        guard let ad = loadedNativeAd else {
            print("❌ Ad not available. Call loadAd() first.")
            return
        }
        
        guard let viewController = viewController,
              let callbacks = callbacks else {
            print("❌ View controller or callbacks is nil")
            return
        }
        
        currentShowBehavior?.destroy()
        
        var behavior: BaseShowBehavior = BaseShowBehavior()
        
        if let pos = positionConfig {
            behavior = PositionDecorator(wrappedBehavior: behavior, x: pos.x, y: pos.y)
            print("🎨 Applied PositionDecorator: (\(pos.x), \(pos.y))")
        }
        
        if let countdown = countdownConfig {
            behavior = CountdownDecorator(
                wrappedBehavior: behavior,
                initialDelay: countdown.initial,
                countdownDuration: countdown.duration,
                closeButtonDelay: countdown.closeDelay
            )
            print("⏱️ Applied CountdownDecorator: initial=\(countdown.initial)s, duration=\(countdown.duration)s, closeDelay=\(countdown.closeDelay)s")
        }
        
        behavior.show(viewController: viewController,
                     nativeAd: ad,
                     layoutName: layoutName,
                     callbacks: callbacks)
        
        currentShowBehavior = behavior
        
        callbacks.onAdShow()
    }
    
    @objc public func destroyAd() {
        print("🗑️ AdmobNativeController: Destroying ad")
        
        resetAllConfigs()
        
        currentShowBehavior?.destroy()
        currentShowBehavior = nil
        
        loadedNativeAd = nil
        
        callbacks?.onAdClosed()
    }
    
    @objc public func isAdAvailable() -> Bool {
        return loadedNativeAd != nil
    }
    
    @objc public func getResponseInfo() -> GADResponseInfo? {
        return loadedNativeAd?.responseInfo
    }
    
    @objc @discardableResult
    public func withCountdown(initial: Float, duration: Float, closeDelay: Float) -> AdmobNativeController {
        if initial < 0 || duration <= 0 || closeDelay < 0 {
            print("⚠️ Invalid countdown timings. Configuration ignored.")
            countdownConfig = nil
        } else {
            countdownConfig = (initial, duration, closeDelay)
            print("✅ Countdown config set: initial=\(initial)s, duration=\(duration)s, closeDelay=\(closeDelay)s")
        }
        return self
    }
    
    @objc @discardableResult
    public func withPosition(x: Int, y: Int) -> AdmobNativeController {
        positionConfig = (x, y)
        print("✅ Position config set: (\(x), \(y))")
        return self
    }
    
    @objc public func getWidthInPixels() -> CGFloat {
        var width: CGFloat = 0
        
        if Thread.isMainThread {
            width = getAdViewWidth()
        } else {
            DispatchQueue.main.sync {
                width = getAdViewWidth()
            }
        }
        
        return width
    }
    
    @objc public func getHeightInPixels() -> CGFloat {
        var height: CGFloat = 0
        
        if Thread.isMainThread {
            height = getAdViewHeight()
        } else {
            DispatchQueue.main.sync {
                height = getAdViewHeight()
            }
        }
        
        return height
    }
    
    private func getAdViewWidth() -> CGFloat {
        guard let behavior = currentShowBehavior as? BaseShowBehavior,
              let rootView = behavior.getRootView() else {
            return 0
        }
        
        if let adContentView = findViewWithAccessibilityIdentifier("ad_content", in: rootView) {
            return adContentView.bounds.width
        }
        
        return rootView.bounds.width
    }
    
    private func getAdViewHeight() -> CGFloat {
        guard let behavior = currentShowBehavior as? BaseShowBehavior,
              let rootView = behavior.getRootView() else {
            return 0
        }
        
        if let adContentView = findViewWithAccessibilityIdentifier("ad_content", in: rootView) {
            return adContentView.bounds.height
        }
        
        return rootView.bounds.height
    }
    
    private func findViewWithAccessibilityIdentifier(_ identifier: String, in view: UIView) -> UIView? {
        if view.accessibilityIdentifier == identifier {
            return view
        }
        
        for subview in view.subviews {
            if let found = findViewWithAccessibilityIdentifier(identifier, in: subview) {
                return found
            }
        }
        
        return nil
    }
    
    private func resetAllConfigs() {
        countdownConfig = nil
        positionConfig = nil
    }
    
    private func setupAdCallbacks(for ad: GADNativeAd) { 
        if ad.mediaContent.hasVideoContent {
            ad.mediaContent.videoController.delegate = self
        }
        
        ad.paidEventHandler = { [weak self] adValue in
            guard let self = self, let callbacks = self.callbacks else { return }
            
            let precisionType = adValue.precision.rawValue
            let valueMicros = adValue.value.int64Value
            let currencyCode = adValue.currencyCode
            
            print("💰 Paid event: \(valueMicros) \(currencyCode) (precision: \(precisionType))")
            callbacks.onPaidEvent(precisionType: precisionType,
                                valueMicros: valueMicros,
                                currencyCode: currencyCode)
        }
    }
}

extension AdmobNativeController: GADAdLoaderDelegate {
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("❌ Ad load failed: \(error.localizedDescription)")
        callbacks?.onAdFailedToLoad(error: error)
    }
}

extension AdmobNativeController: GADNativeAdLoaderDelegate {
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("✅ Ad loaded successfully")
        
        self.loadedNativeAd = nativeAd
        
        setupAdCallbacks(for: nativeAd)
        
        callbacks?.onAdLoaded()
    }
}

extension AdmobNativeController: GADVideoControllerDelegate {
    
    public func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
        print("▶️ Video started")
        callbacks?.onVideoStart()
        callbacks?.onVideoPlay()
    }
    
    public func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
        print("⏸️ Video paused")
        callbacks?.onVideoPause()
    }
    
    public func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("⏹️ Video ended")
        callbacks?.onVideoEnd()
    }
    
    public func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
        print("🔇 Video muted")
        callbacks?.onVideoMute(isMuted: true)
    }
    
    public func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
        print("🔊 Video unmuted")
        callbacks?.onVideoMute(isMuted: false)
    }
}

extension AdmobNativeController: GADNativeAdDelegate {
    
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("👁️ Ad impression recorded")
        callbacks?.onAdDidRecordImpression()
    }
    
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("👆 Ad clicked")
        callbacks?.onAdClicked()
    }
    
    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("📱 Ad will present full screen")
        callbacks?.onAdShowedFullScreenContent()
    }
    
    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("📱 Ad dismissed full screen")
        callbacks?.onAdDismissedFullScreenContent()
    }
}
