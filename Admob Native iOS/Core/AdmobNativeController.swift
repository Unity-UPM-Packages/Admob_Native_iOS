//
//  AdmobNativeController.swift
//  Admob Native iOS
//
//  Bộ điều khiển chính quản lý tải, hiển thị, video events, paid events và response info của Native Ad.
//

import UIKit
import GoogleMobileAds

public final class AdmobNativeController: NSObject {
    
    private var adLoader: GADAdLoader?
    private var loadedNativeAd: GADNativeAd?
    private var currentShowBehavior: IShowBehavior?
    
    public var callbacks: NativeAdCallbacks?
    public var clientPtr: UnsafeMutableRawPointer?
    
    // Configurations
    private struct CountdownConfig {
        let initial: Float
        let duration: Float
        let closeDelay: Float
    }
    private var countdownConfig: CountdownConfig?
    
    private struct PositionConfig {
        let x: Int
        let y: Int
    }
    private var positionConfig: PositionConfig?
    
    // MARK: - Init
    public override init() {
        super.init()
    }
    
    // MARK: - Root View Controller Helper
    private func getUnityViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return keyWindow.rootViewController
        }
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    // MARK: - Load Ad
    public func loadAd(adUnitId: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let rootVC = self.getUnityViewController() else {
                let errorMsg = "AdmobNativeController: RootViewController not found"
                errorMsg.withCString { cStr in
                    self.callbacks?.onAdFailedToLoad?(self.clientPtr, cStr)
                }
                return
            }
            
            let videoOptions = GADVideoOptions()
            videoOptions.startMuted = true
            videoOptions.customControlsRequested = false
            videoOptions.clickToExpandRequested = false
            
            let adLoader = GADAdLoader(
                adUnitID: adUnitId,
                rootViewController: rootVC,
                adTypes: [.native],
                options: [videoOptions]
            )
            
            adLoader.delegate = self
            self.adLoader = adLoader
            
            let request = GADRequest()
            adLoader.load(request)
        }
    }
    
    // MARK: - Show Ad
    public func showAd(layoutName: String) {
        guard let nativeAd = loadedNativeAd else {
            print("[AdmobNativeController] No ad available to show. Call loadAd() first.")
            return
        }
        
        guard let rootVC = getUnityViewController() else {
            print("[AdmobNativeController] Cannot show ad: RootViewController not found.")
            return
        }
        
        currentShowBehavior?.destroy()
        
        var behavior: BaseShowBehavior = BaseShowBehavior()
        
        if let pos = positionConfig {
            behavior = PositionDecorator(
                wrappedBehavior: behavior,
                positionX: pos.x,
                positionY: pos.y
            )
        }
        
        if let countdown = countdownConfig {
            behavior = CountdownDecorator(
                wrappedBehavior: behavior,
                initialDelaySeconds: countdown.initial,
                countdownDurationSeconds: countdown.duration,
                closeButtonDelaySeconds: countdown.closeDelay
            )
        }
        
        behavior.show(
            viewController: rootVC,
            nativeAd: nativeAd,
            layoutName: layoutName,
            callbacks: callbacks,
            clientPtr: clientPtr
        )
        
        currentShowBehavior = behavior
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onAdShow?(self.clientPtr)
        }
    }
    
    // MARK: - Destroy Ad
    public func destroyAd() {
        let performDestroy = { [weak self] in
            guard let self = self else { return }
            self.countdownConfig = nil
            self.positionConfig = nil
            
            self.currentShowBehavior?.destroy()
            self.currentShowBehavior = nil
            
            self.loadedNativeAd = nil
            self.adLoader = nil
            
            self.callbacks?.onAdClosed?(self.clientPtr)
        }
        
        if Thread.isMainThread {
            performDestroy()
        } else {
            DispatchQueue.main.async {
                performDestroy()
            }
        }
    }
    
    // MARK: - Ad Availability
    public func isAdAvailable() -> Bool {
        return loadedNativeAd != nil
    }
    
    // MARK: - Builder Methods
    @discardableResult
    public func withCountdown(initial: Float, duration: Float, closeDelay: Float) -> AdmobNativeController {
        if initial < 0 || duration <= 0 || closeDelay < 0 {
            self.countdownConfig = nil
        } else {
            self.countdownConfig = CountdownConfig(initial: initial, duration: duration, closeDelay: closeDelay)
        }
        return self
    }
    
    @discardableResult
    public func withPosition(x: Int, y: Int) -> AdmobNativeController {
        self.positionConfig = PositionConfig(x: x, y: y)
        return self
    }
    
    // MARK: - View Sizing
    public func getWidthInPixels() -> Float {
        guard let adView = (currentShowBehavior as? BaseShowBehavior)?.getCurrentAdView() else {
            return 0.0
        }
        let scale = UIScreen.main.scale
        return Float(adView.bounds.width * scale)
    }
    
    public func getHeightInPixels() -> Float {
        guard let adView = (currentShowBehavior as? BaseShowBehavior)?.getCurrentAdView() else {
            return 0.0
        }
        let scale = UIScreen.main.scale
        return Float(adView.bounds.height * scale)
    }
    
    public func updateAdViewSize(widthPx: Int, heightPx: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let adView = (self.currentShowBehavior as? BaseShowBehavior)?.getCurrentAdView() else { return }
            
            let scale = UIScreen.main.scale
            let widthPt = CGFloat(widthPx) / scale
            let heightPt = CGFloat(heightPx) / scale
            
            var frame = adView.frame
            if widthPx > 0 { frame.size.width = widthPt }
            if heightPx > 0 { frame.size.height = heightPt }
            adView.frame = frame
        }
    }
    
    // MARK: - Response Info Getters
    public func getResponseId() -> String? {
        return loadedNativeAd?.responseInfo.responseIdentifier
    }
    
    public func getMediationAdapterClassName() -> String? {
        return loadedNativeAd?.responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName
    }
    
    public func getAdapterResponsesCount() -> Int {
        return loadedNativeAd?.responseInfo.adNetworkInfoArray.count ?? 0
    }
    
    public func getLoadedAdapterResponse() -> GADAdNetworkResponseInfo? {
        return loadedNativeAd?.responseInfo.loadedAdNetworkResponseInfo
    }
    
    public func getAdapterResponseAt(index: Int) -> GADAdNetworkResponseInfo? {
        guard let array = loadedNativeAd?.responseInfo.adNetworkInfoArray, index >= 0, index < array.count else {
            return nil
        }
        return array[index]
    }
}

// MARK: - GADAdLoaderDelegate & GADNativeAdLoaderDelegate
extension AdmobNativeController: GADNativeAdLoaderDelegate, GADNativeAdDelegate, GADVideoControllerDelegate {
    
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let errorMsg = error.localizedDescription
            errorMsg.withCString { cStr in
                self.callbacks?.onAdFailedToLoad?(self.clientPtr, cStr)
            }
        }
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadedNativeAd = nativeAd
            nativeAd.delegate = self
            nativeAd.mediaContent.videoController.delegate = self
            
            // Paid Event Listener
            nativeAd.paidEventHandler = { [weak self] adValue in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let precision = Int32(adValue.precision.rawValue)
                    let micros = adValue.value.multiplying(byPowerOf10: 6).int64Value
                    let currency = adValue.currencyCode
                    
                    currency.withCString { cStr in
                        self.callbacks?.onPaidEvent?(self.clientPtr, precision, micros, cStr)
                    }
                }
            }
            
            self.callbacks?.onAdLoaded?(self.clientPtr)
        }
    }
    
    // MARK: - GADNativeAdDelegate
    public func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onAdDidRecordImpression?(self.clientPtr)
        }
    }
    
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onAdClicked?(self.clientPtr)
        }
    }
    
    public func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onAdShowedFullScreenContent?(self.clientPtr)
        }
    }
    
    public func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onAdDismissedFullScreenContent?(self.clientPtr)
        }
    }
    
    // MARK: - GADVideoControllerDelegate
    public func videoControllerDidPlayVideo(_ videoController: GADVideoController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onVideoPlay?(self.clientPtr)
        }
    }
    
    public func videoControllerDidPauseVideo(_ videoController: GADVideoController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onVideoPause?(self.clientPtr)
        }
    }
    
    public func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onVideoEnd?(self.clientPtr)
        }
    }
    
    public func videoControllerDidMuteVideo(_ videoController: GADVideoController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onVideoMute?(self.clientPtr, true)
        }
    }
    
    public func videoControllerDidUnmuteVideo(_ videoController: GADVideoController) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.callbacks?.onVideoMute?(self.clientPtr, false)
        }
    }
}
