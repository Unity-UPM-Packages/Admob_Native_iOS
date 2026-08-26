//
//  BaseShowBehavior.swift
//  Admob Native iOS
//
//  Base behavior hiển thị Native Ad lên View Hierarchy của Unity iOS.
//

import UIKit
import GoogleMobileAds

// Custom Container View cho phép touch xuyên qua vùng trong suốt
open class PassthroughContainerView: UIView {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        // Nếu chạm vào chính container (vùng trong suốt), trả về nil để touch xuyên qua màn hình Game
        return hitView == self ? nil : hitView
    }
}

open class BaseShowBehavior: IShowBehavior {
    
    internal var rootView: UIView?
    internal var currentAdView: BaseNativeAdLayoutView?
    private weak var currentViewController: UIViewController?
    
    public init() {}
    
    open func show(
        viewController: UIViewController,
        nativeAd: GADNativeAd,
        layoutName: String,
        callbacks: NativeAdCallbacks?,
        clientPtr: UnsafeMutableRawPointer?
    ) {
        self.currentViewController = viewController
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Container bao bọc toàn bộ màn hình (hỗ trợ touch xuyên qua vùng trong suốt)
            let container = PassthroughContainerView(frame: viewController.view.bounds)
            container.translatesAutoresizingMaskIntoConstraints = false
            container.backgroundColor = .clear
            self.rootView = container
            
            viewController.view.addSubview(container)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: viewController.view.topAnchor),
                container.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
                container.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
                container.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
            ])
            
            // 2. Khởi tạo layout view theo tên
            let adView = NativeLayoutFactory.createLayout(layoutName: layoutName)
            self.currentAdView = adView
            
            adView.onCloseClicked = { [weak self] in
                if let callbacks = callbacks, let clientPtr = clientPtr {
                    callbacks.onAdClosed?(clientPtr)
                }
                self?.destroy()
            }
            
            adView.populate(nativeAd: nativeAd)
            container.addSubview(adView)
            
            NSLayoutConstraint.activate([
                adView.topAnchor.constraint(equalTo: container.topAnchor),
                adView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                adView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                adView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
            
            viewController.view.bringSubviewToFront(container)
        }
    }
    
    open func destroy() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.currentAdView?.nativeAd = nil
            self.currentAdView?.removeFromSuperview()
            self.currentAdView = nil
            
            self.rootView?.removeFromSuperview()
            self.rootView = nil
        }
    }
    
    open func getRootView() -> UIView? {
        return self.rootView
    }
    
    open func getCurrentAdView() -> BaseNativeAdLayoutView? {
        return self.currentAdView
    }
}
