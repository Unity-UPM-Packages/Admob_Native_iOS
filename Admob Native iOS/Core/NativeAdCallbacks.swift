//
//  NativeAdCallbacks.swift
//  Admob Native iOS
//
//  Định nghĩa các function pointer callbacks để chuyển tiếp sự kiện từ Swift về Unity C#.
//

import Foundation

public typealias UnityVoidCallback = @convention(c) (UnsafeMutableRawPointer?) -> Void
public typealias UnityErrorCallback = @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<CChar>?) -> Void
public typealias UnityPaidEventCallback = @convention(c) (UnsafeMutableRawPointer?, Int32, Int64, UnsafePointer<CChar>?) -> Void
public typealias UnityVideoMuteCallback = @convention(c) (UnsafeMutableRawPointer?, Bool) -> Void

public struct NativeAdCallbacks {
    public var onAdLoaded: UnityVoidCallback?
    public var onAdFailedToLoad: UnityErrorCallback?
    public var onAdShow: UnityVoidCallback?
    public var onAdClosed: UnityVoidCallback?
    public var onPaidEvent: UnityPaidEventCallback?
    public var onAdDidRecordImpression: UnityVoidCallback?
    public var onAdClicked: UnityVoidCallback?
    public var onVideoStart: UnityVoidCallback?
    public var onVideoEnd: UnityVoidCallback?
    public var onVideoMute: UnityVideoMuteCallback?
    public var onVideoPlay: UnityVideoPlayCallback?
    public var onVideoPause: UnityVideoPauseCallback?
    public var onAdShowedFullScreenContent: UnityVoidCallback?
    public var onAdDismissedFullScreenContent: UnityVoidCallback?
    
    public typealias UnityVideoPlayCallback = UnityVoidCallback
    public typealias UnityVideoPauseCallback = UnityVoidCallback
    
    public init() {}
}
