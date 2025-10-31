import Foundation
import UIKit
import GoogleMobileAds

@objc public protocol IShowBehavior: AnyObject {
    func show(viewController: UIViewController,
              nativeAd: GADNativeAd,
              layoutName: String,
              callbacks: NativeAdCallbacks)
    
    func destroy()
}
