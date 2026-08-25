//
//  IShowBehavior.swift
//  Admob Native iOS
//
//  Protocol định nghĩa hành vi hiển thị và hủy bỏ quảng cáo Native.
//

import UIKit
import GoogleMobileAds

public protocol IShowBehavior: AnyObject {
    func show(
        viewController: UIViewController,
        nativeAd: GADNativeAd,
        layoutName: String,
        callbacks: NativeAdCallbacks?,
        clientPtr: UnsafeMutableRawPointer?
    )
    
    func destroy()
    func getRootView() -> UIView?
}
