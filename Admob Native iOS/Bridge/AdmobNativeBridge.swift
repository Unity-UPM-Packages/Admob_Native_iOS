//
//  AdmobNativeBridge.swift
//  Admob Native iOS
//
//  Export các C-functions (@_cdecl) kết nối trực tiếp với [DllImport("__Internal")] trong Unity C#.
//

import Foundation

// MARK: - Controller Lifecycle

@_cdecl("AdmobNative_Create")
public func AdmobNative_Create() -> UnsafeMutableRawPointer {
    let controller = AdmobNativeController()
    let unmanaged = Unmanaged.passRetained(controller)
    let ptr = unmanaged.toOpaque()
    controller.clientPtr = ptr
    return ptr
}

@_cdecl("AdmobNative_Destroy")
public func AdmobNative_Destroy(_ handle: UnsafeMutableRawPointer?) {
    guard let handle = handle else { return }
    let unmanaged = Unmanaged<AdmobNativeController>.fromOpaque(handle)
    let controller = unmanaged.takeUnretainedValue()
    controller.destroyAd()
    unmanaged.release()
}

@_cdecl("AdmobNative_RegisterCallbacks")
public func AdmobNative_RegisterCallbacks(
    _ handle: UnsafeMutableRawPointer?,
    _ onAdLoaded: UnityVoidCallback?,
    _ onAdFailedToLoad: UnityErrorCallback?,
    _ onAdShow: UnityVoidCallback?,
    _ onAdClosed: UnityVoidCallback?,
    _ onPaidEvent: UnityPaidEventCallback?,
    _ onAdDidRecordImpression: UnityVoidCallback?,
    _ onAdClicked: UnityVoidCallback?,
    _ onVideoStart: UnityVoidCallback?,
    _ onVideoEnd: UnityVoidCallback?,
    _ onVideoMute: UnityVideoMuteCallback?,
    _ onVideoPlay: UnityVoidCallback?,
    _ onVideoPause: UnityVoidCallback?,
    _ onAdShowedFullScreenContent: UnityVoidCallback?,
    _ onAdDismissedFullScreenContent: UnityVoidCallback?
) {
    guard let handle = handle else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    
    var callbacks = NativeAdCallbacks()
    callbacks.onAdLoaded = onAdLoaded
    callbacks.onAdFailedToLoad = onAdFailedToLoad
    callbacks.onAdShow = onAdShow
    callbacks.onAdClosed = onAdClosed
    callbacks.onPaidEvent = onPaidEvent
    callbacks.onAdDidRecordImpression = onAdDidRecordImpression
    callbacks.onAdClicked = onAdClicked
    callbacks.onVideoStart = onVideoStart
    callbacks.onVideoEnd = onVideoEnd
    callbacks.onVideoMute = onVideoMute
    callbacks.onVideoPlay = onVideoPlay
    callbacks.onVideoPause = onVideoPause
    callbacks.onAdShowedFullScreenContent = onAdShowedFullScreenContent
    callbacks.onAdDismissedFullScreenContent = onAdDismissedFullScreenContent
    
    controller.callbacks = callbacks
}

// MARK: - Ad Actions

@_cdecl("AdmobNative_LoadAd")
public func AdmobNative_LoadAd(_ handle: UnsafeMutableRawPointer?, _ adUnitId: UnsafePointer<CChar>?) {
    guard let handle = handle, let adUnitId = adUnitId else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    let unitIdString = String(cString: adUnitId)
    controller.loadAd(adUnitId: unitIdString)
}

@_cdecl("AdmobNative_ShowAd")
public func AdmobNative_ShowAd(_ handle: UnsafeMutableRawPointer?, _ layoutName: UnsafePointer<CChar>?) {
    guard let handle = handle, let layoutName = layoutName else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    let layoutString = String(cString: layoutName)
    controller.showAd(layoutName: layoutString)
}

@_cdecl("AdmobNative_DestroyAd")
public func AdmobNative_DestroyAd(_ handle: UnsafeMutableRawPointer?) {
    guard let handle = handle else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    controller.destroyAd()
}

@_cdecl("AdmobNative_IsAdAvailable")
public func AdmobNative_IsAdAvailable(_ handle: UnsafeMutableRawPointer?) -> Bool {
    guard let handle = handle else { return false }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    return controller.isAdAvailable()
}

// MARK: - Builder Configurations

@_cdecl("AdmobNative_WithCountdown")
public func AdmobNative_WithCountdown(
    _ handle: UnsafeMutableRawPointer?,
    _ initial: Float,
    _ duration: Float,
    _ closeDelay: Float
) {
    guard let handle = handle else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    controller.withCountdown(initial: initial, duration: duration, closeDelay: closeDelay)
}

@_cdecl("AdmobNative_WithPosition")
public func AdmobNative_WithPosition(_ handle: UnsafeMutableRawPointer?, _ x: Int32, _ y: Int32) {
    guard let handle = handle else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    controller.withPosition(x: Int(x), y: Int(y))
}

// MARK: - Measurements & Sizing

@_cdecl("AdmobNative_GetWidthInPixels")
public func AdmobNative_GetWidthInPixels(_ handle: UnsafeMutableRawPointer?) -> Float {
    guard let handle = handle else { return 0.0 }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    return controller.getWidthInPixels()
}

@_cdecl("AdmobNative_GetHeightInPixels")
public func AdmobNative_GetHeightInPixels(_ handle: UnsafeMutableRawPointer?) -> Float {
    guard let handle = handle else { return 0.0 }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    return controller.getHeightInPixels()
}

@_cdecl("AdmobNative_UpdateAdViewSize")
public func AdmobNative_UpdateAdViewSize(_ handle: UnsafeMutableRawPointer?, _ width: Int32, _ height: Int32) {
    guard let handle = handle else { return }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    controller.updateAdViewSize(widthPx: Int(width), heightPx: Int(height))
}

// MARK: - Response Info

@_cdecl("AdmobNative_GetResponseId")
public func AdmobNative_GetResponseId(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    guard let responseId = controller.getResponseId() else { return nil }
    return strdup(responseId)
}

@_cdecl("AdmobNative_GetMediationAdapterClassName")
public func AdmobNative_GetMediationAdapterClassName(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    guard let className = controller.getMediationAdapterClassName() else { return nil }
    return strdup(className)
}

@_cdecl("AdmobNative_GetAdapterResponsesCount")
public func AdmobNative_GetAdapterResponsesCount(_ handle: UnsafeMutableRawPointer?) -> Int32 {
    guard let handle = handle else { return 0 }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    return Int32(controller.getAdapterResponsesCount())
}

@_cdecl("AdmobNative_GetLoadedAdapterResponse")
public func AdmobNative_GetLoadedAdapterResponse(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutableRawPointer? {
    guard let handle = handle else { return nil }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    guard let adapter = controller.getLoadedAdapterResponse() else { return nil }
    return Unmanaged.passRetained(adapter).toOpaque()
}

@_cdecl("AdmobNative_GetAdapterResponseAt")
public func AdmobNative_GetAdapterResponseAt(_ handle: UnsafeMutableRawPointer?, _ index: Int32) -> UnsafeMutableRawPointer? {
    guard let handle = handle else { return nil }
    let controller = Unmanaged<AdmobNativeController>.fromOpaque(handle).takeUnretainedValue()
    guard let adapter = controller.getAdapterResponseAt(index: Int(index)) else { return nil }
    return Unmanaged.passRetained(adapter).toOpaque()
}

// MARK: - Adapter Response Info

@_cdecl("AdmobNative_AdapterResponse_GetAdapterClassName")
public func AdmobNative_AdapterResponse_GetAdapterClassName(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return strdup(info.adNetworkClassName)
}

@_cdecl("AdmobNative_AdapterResponse_GetLatencyMillis")
public func AdmobNative_AdapterResponse_GetLatencyMillis(_ handle: UnsafeMutableRawPointer?) -> Int64 {
    guard let handle = handle else { return 0 }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return Int64(info.latency * 1000.0)
}

@_cdecl("AdmobNative_AdapterResponse_GetAdSourceName")
public func AdmobNative_AdapterResponse_GetAdSourceName(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return strdup(info.adSourceName)
}

@_cdecl("AdmobNative_AdapterResponse_GetAdSourceId")
public func AdmobNative_AdapterResponse_GetAdSourceId(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return strdup(info.adSourceID)
}

@_cdecl("AdmobNative_AdapterResponse_GetAdSourceInstanceName")
public func AdmobNative_AdapterResponse_GetAdSourceInstanceName(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return strdup(info.adSourceInstanceName)
}

@_cdecl("AdmobNative_AdapterResponse_GetAdSourceInstanceId")
public func AdmobNative_AdapterResponse_GetAdSourceInstanceId(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    return strdup(info.adSourceInstanceID)
}

@_cdecl("AdmobNative_AdapterResponse_GetAdError")
public func AdmobNative_AdapterResponse_GetAdError(_ handle: UnsafeMutableRawPointer?) -> UnsafeMutablePointer<CChar>? {
    guard let handle = handle else { return nil }
    let info = Unmanaged<GADAdNetworkResponseInfo>.fromOpaque(handle).takeUnretainedValue()
    guard let error = info.error else { return nil }
    return strdup(error.localizedDescription)
}
