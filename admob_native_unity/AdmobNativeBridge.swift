import Foundation
import UIKit
import GoogleMobileAds

// MARK: - Callback Function Pointer Types

/// Callback không có tham số
public typealias VoidCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void

/// Callback với error message
public typealias ErrorCallback = @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<CChar>?) -> Void

/// Callback cho paid event
public typealias PaidEventCallback = @convention(c) (UnsafeMutableRawPointer?, Int32, Int64, UnsafePointer<CChar>?) -> Void

/// Callback cho video mute
public typealias VideoMuteCallback = @convention(c) (UnsafeMutableRawPointer?, Bool) -> Void

// MARK: - Callback Wrapper Class

/// Wrapper class implement NativeAdCallbacks protocol và chuyển đổi sang C function pointers
class BridgeCallbacks: NSObject, NativeAdCallbacks {
    
    private var handle: UnsafeMutableRawPointer?
    
    // Stored callback function pointers
    var onAdLoadedCallback: VoidCallback?
    var onAdFailedToLoadCallback: ErrorCallback?
    var onAdShowCallback: VoidCallback?
    var onAdClosedCallback: VoidCallback?
    var onPaidEventCallback: PaidEventCallback?
    var onAdDidRecordImpressionCallback: VoidCallback?
    var onAdClickedCallback: VoidCallback?
    var onVideoStartCallback: VoidCallback?
    var onVideoEndCallback: VoidCallback?
    var onVideoMuteCallback: VideoMuteCallback?
    var onVideoPlayCallback: VoidCallback?
    var onVideoPauseCallback: VoidCallback?
    var onAdShowedFullScreenContentCallback: VoidCallback?
    var onAdDismissedFullScreenContentCallback: VoidCallback?

    init(handle: UnsafeMutableRawPointer?) {
        self.handle = handle
    }
    
    // MARK: - NativeAdCallbacks Implementation
    
    func onAdLoaded() {
        onAdLoadedCallback?(handle)
    }
    
    func onAdFailedToLoad(error: Error) {
        let message = error.localizedDescription
        message.withCString { cString in
            onAdFailedToLoadCallback?(handle, cString)
        }
    }
    
    func onAdShow() {
        onAdShowCallback?(handle)
    }
    
    func onAdClosed() {
        onAdClosedCallback?(handle)
    }
    
    func onPaidEvent(precisionType: Int, valueMicros: Int64, currencyCode: String) {
        currencyCode.withCString { cString in
            onPaidEventCallback?(handle, Int32(precisionType), valueMicros, cString)
        }
    }
    
    func onAdDidRecordImpression() {
        onAdDidRecordImpressionCallback?(handle)
    }
    
    func onAdClicked() {
        onAdClickedCallback?(handle)
    }
    
    func onVideoStart() {
        onVideoStartCallback?(handle)
    }
    
    func onVideoEnd() {
        onVideoEndCallback?(handle)
    }
    
    func onVideoMute(isMuted: Bool) {
        onVideoMuteCallback?(handle, isMuted)
    }
    
    func onVideoPlay() {
        onVideoPlayCallback?(handle)
    }
    
    func onVideoPause() {
        onVideoPauseCallback?(handle)
    }
    
    func onAdShowedFullScreenContent() {
        onAdShowedFullScreenContentCallback?(handle)
    }
    
    func onAdDismissedFullScreenContent() {
        onAdDismissedFullScreenContentCallback?(handle)
    }
}

// MARK: - Instance Management

/// Dictionary lưu trữ các controller instances theo handle ID
private var controllers: [String: AdmobNativeController] = [:]

/// Dictionary lưu trữ các callback wrappers theo handle ID
private var callbacks: [String: BridgeCallbacks] = [:]

/// Dictionary lưu trữ response info strings (để giữ reference tránh dealloc)
private var responseInfoCache: [String: (responseId: String, adapterClassName: String)] = [:]

// MARK: - C Bridge Functions

/// Tạo một AdmobNativeController instance mới
/// - Returns: Handle (void*) để sử dụng trong các function calls tiếp theo
@_cdecl("AdmobNative_Create")
public func AdmobNative_Create() -> UnsafeMutableRawPointer? {
    let handleId = UUID().uuidString
    let handle = UnsafeMutableRawPointer(mutating: (handleId as NSString).utf8String)
    
    // Lấy root view controller
    guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
        print("❌ AdmobNative_Create: Cannot get root view controller")
        return nil
    }
    
    // Tạo callback wrapper và controller, sau đó lưu chúng
    let bridgeCallbacks = BridgeCallbacks(handle: handle)
    let controller = AdmobNativeController(viewController: viewController, callbacks: bridgeCallbacks)
    
    controllers[handleId] = controller
    callbacks[handleId] = bridgeCallbacks
    
    print("✅ AdmobNative_Create: Created controller with handle: \(handleId)")
    
    return handle
}

/// Đăng ký các callback function pointers
@_cdecl("AdmobNative_RegisterCallbacks")
public func AdmobNative_RegisterCallbacks(
    _ handle: UnsafeMutableRawPointer?,
    _ onAdLoaded: VoidCallback?,
    _ onAdFailedToLoad: ErrorCallback?,
    _ onAdShow: VoidCallback?,
    _ onAdClosed: VoidCallback?,
    _ onPaidEvent: PaidEventCallback?,
    _ onAdDidRecordImpression: VoidCallback?,
    _ onAdClicked: VoidCallback?,
    _ onVideoStart: VoidCallback?,
    _ onVideoEnd: VoidCallback?,
    _ onVideoMute: VideoMuteCallback?,
    _ onVideoPlay: VoidCallback?,
    _ onVideoPause: VoidCallback?,
    _ onAdShowedFullScreenContent: VoidCallback?,
    _ onAdDismissedFullScreenContent: VoidCallback?
) {
    guard let handleId = extractHandleId(handle),
          let bridgeCallbacks = callbacks[handleId] else {
        print("❌ AdmobNative_RegisterCallbacks: Invalid handle")
        return
    }
    
    bridgeCallbacks.onAdLoadedCallback = onAdLoaded
    bridgeCallbacks.onAdFailedToLoadCallback = onAdFailedToLoad
    bridgeCallbacks.onAdShowCallback = onAdShow
    bridgeCallbacks.onAdClosedCallback = onAdClosed
    bridgeCallbacks.onPaidEventCallback = onPaidEvent
    bridgeCallbacks.onAdDidRecordImpressionCallback = onAdDidRecordImpression
    bridgeCallbacks.onAdClickedCallback = onAdClicked
    bridgeCallbacks.onVideoStartCallback = onVideoStart
    bridgeCallbacks.onVideoEndCallback = onVideoEnd
    bridgeCallbacks.onVideoMuteCallback = onVideoMute
    bridgeCallbacks.onVideoPlayCallback = onVideoPlay
    bridgeCallbacks.onVideoPauseCallback = onVideoPause
    bridgeCallbacks.onAdShowedFullScreenContentCallback = onAdShowedFullScreenContent
    bridgeCallbacks.onAdDismissedFullScreenContentCallback = onAdDismissedFullScreenContent
    
    print("✅ AdmobNative_RegisterCallbacks: Callbacks registered")
}

/// Load quảng cáo
@_cdecl("AdmobNative_LoadAd")
public func AdmobNative_LoadAd(
    _ handle: UnsafeMutableRawPointer?,
    _ adUnitId: UnsafePointer<CChar>?
) {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId],
          let adUnitIdStr = adUnitId.flatMap({ String(cString: $0) }) else {
        print("❌ AdmobNative_LoadAd: Invalid parameters")
        return
    }
    
    let request = GADRequest()
    controller.loadAd(adUnitId: adUnitIdStr, request: request)
}

/// Hiển thị quảng cáo
@_cdecl("AdmobNative_ShowAd")
public func AdmobNative_ShowAd(
    _ handle: UnsafeMutableRawPointer?,
    _ layoutName: UnsafePointer<CChar>?
) {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId],
          let layoutNameStr = layoutName.flatMap({ String(cString: $0) }) else {
        print("❌ AdmobNative_ShowAd: Invalid parameters")
        return
    }
    
    controller.showAd(layoutName: layoutNameStr)
}

/// Cấu hình countdown
@_cdecl("AdmobNative_WithCountdown")
public func AdmobNative_WithCountdown(
    _ handle: UnsafeMutableRawPointer?,
    _ initial: Float,
    _ duration: Float,
    _ closeDelay: Float
) {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_WithCountdown: Invalid handle")
        return
    }
    
    controller.withCountdown(initial: initial, duration: duration, closeDelay: closeDelay)
}

/// Cấu hình position
@_cdecl("AdmobNative_WithPosition")
public func AdmobNative_WithPosition(
    _ handle: UnsafeMutableRawPointer?,
    _ x: Int32,
    _ y: Int32
) {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_WithPosition: Invalid handle")
        return
    }
    
    controller.withPosition(x: Int(x), y: Int(y))
}

/// Hủy quảng cáo
@_cdecl("AdmobNative_DestroyAd")
public func AdmobNative_DestroyAd(_ handle: UnsafeMutableRawPointer?) {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_DestroyAd: Invalid handle")
        return
    }
    
    controller.destroyAd()
}

/// Kiểm tra ad có available không
@_cdecl("AdmobNative_IsAdAvailable")
public func AdmobNative_IsAdAvailable(_ handle: UnsafeMutableRawPointer?) -> Bool {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_IsAdAvailable: Invalid handle")
        return false
    }
    
    return controller.isAdAvailable()
}

/// Lấy width của ad view
@_cdecl("AdmobNative_GetWidthInPixels")
public func AdmobNative_GetWidthInPixels(_ handle: UnsafeMutableRawPointer?) -> Float {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_GetWidthInPixels: Invalid handle")
        return -1.0
    }
    
    return Float(controller.getWidthInPixels())
}

/// Lấy height của ad view
@_cdecl("AdmobNative_GetHeightInPixels")
public func AdmobNative_GetHeightInPixels(_ handle: UnsafeMutableRawPointer?) -> Float {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_GetHeightInPixels: Invalid handle")
        return -1.0
    }
    
    return Float(controller.getHeightInPixels())
}

/// Destroy controller instance và cleanup
@_cdecl("AdmobNative_Destroy")
public func AdmobNative_Destroy(_ handle: UnsafeMutableRawPointer?) {
    guard let handleId = extractHandleId(handle) else {
        print("❌ AdmobNative_Destroy: Invalid handle")
        return
    }
    
    controllers[handleId]?.destroyAd()
    controllers.removeValue(forKey: handleId)
    callbacks.removeValue(forKey: handleId)
    responseInfoCache.removeValue(forKey: handleId) // Cleanup cache
    
    print("✅ AdmobNative_Destroy: Destroyed controller with handle: \(handleId)")
}

// MARK: - Response Info Functions

/// Lấy Response ID từ ad response
@_cdecl("AdmobNative_GetResponseId")
public func AdmobNative_GetResponseId(_ handle: UnsafeMutableRawPointer?) -> UnsafePointer<CChar>? {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_GetResponseId: Invalid handle")
        return nil
    }
    
    // Lấy response info từ controller
    guard let responseInfo = controller.getResponseInfo() else {
        print("⚠️ AdmobNative_GetResponseId: No response info available")
        let defaultValue = "unknown"
        // Cache string để giữ reference
        responseInfoCache[handleId] = (defaultValue, responseInfoCache[handleId]?.adapterClassName ?? "GoogleMobileAds")
        return (defaultValue as NSString).utf8String
    }
    
    let responseId = responseInfo.responseIdentifier ?? "unknown"
    print("✅ AdmobNative_GetResponseId: \(responseId)")
    
    // Cache string để giữ reference, tránh bị deallocate
    responseInfoCache[handleId] = (responseId, responseInfoCache[handleId]?.adapterClassName ?? "GoogleMobileAds")
    
    // Return pointer từ cached string
    return (responseId as NSString).utf8String
}

/// Lấy Mediation Adapter Class Name
@_cdecl("AdmobNative_GetMediationAdapterClassName")
public func AdmobNative_GetMediationAdapterClassName(_ handle: UnsafeMutableRawPointer?) -> UnsafePointer<CChar>? {
    guard let handleId = extractHandleId(handle),
          let controller = controllers[handleId] else {
        print("❌ AdmobNative_GetMediationAdapterClassName: Invalid handle")
        return nil
    }
    
    // Lấy response info từ controller
    guard let responseInfo = controller.getResponseInfo() else {
        print("⚠️ AdmobNative_GetMediationAdapterClassName: No response info available")
        let defaultValue = "GoogleMobileAds"
        // Cache string để giữ reference
        responseInfoCache[handleId] = (responseInfoCache[handleId]?.responseId ?? "unknown", defaultValue)
        return (defaultValue as NSString).utf8String
    }
    
    let className = responseInfo.loadedAdNetworkResponseInfo?.adNetworkClassName ?? "GoogleMobileAds"
    print("✅ AdmobNative_GetMediationAdapterClassName: \(className)")
    
    // Cache string để giữ reference, tránh bị deallocate
    responseInfoCache[handleId] = (responseInfoCache[handleId]?.responseId ?? "unknown", className)
    
    // Return pointer từ cached string
    return (className as NSString).utf8String
}


// MARK: - Helper Functions

/// Extract handle ID từ void pointer
private func extractHandleId(_ handle: UnsafeMutableRawPointer?) -> String? {
    guard let handle = handle else { return nil }
    return String(cString: handle.assumingMemoryBound(to: CChar.self))
}
