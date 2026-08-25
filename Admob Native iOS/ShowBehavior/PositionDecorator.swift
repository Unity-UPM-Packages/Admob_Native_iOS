//
//  PositionDecorator.swift
//  Admob Native iOS
//
//  Decorator căn chỉnh vị trí hiển thị (x, y) của Native Ad theo pixel từ Unity.
//

import UIKit
import GoogleMobileAds

public final class PositionDecorator: BaseShowBehavior {
    
    private let wrappedBehavior: BaseShowBehavior
    private let positionX: Int
    private let positionY: Int
    
    public init(
        wrappedBehavior: BaseShowBehavior,
        positionX: Int,
        positionY: Int
    ) {
        self.wrappedBehavior = wrappedBehavior
        self.positionX = positionX
        self.positionY = positionY
        super.init()
    }
    
    public override func show(
        viewController: UIViewController,
        nativeAd: GADNativeAd,
        layoutName: String,
        callbacks: NativeAdCallbacks?,
        clientPtr: UnsafeMutableRawPointer?
    ) {
        wrappedBehavior.show(
            viewController: viewController,
            nativeAd: nativeAd,
            layoutName: layoutName,
            callbacks: callbacks,
            clientPtr: clientPtr
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.rootView = self.wrappedBehavior.getRootView()
            self.currentAdView = self.wrappedBehavior.getCurrentAdView()
            
            guard let adView = self.currentAdView else { return }
            
            // Quy đổi từ pixel của Unity sang point của iOS
            let scale = UIScreen.main.scale
            let pointX = CGFloat(self.positionX) / scale
            let pointY = CGFloat(self.positionY) / scale
            
            adView.translatesAutoresizingMaskIntoConstraints = true
            adView.frame.origin = CGPoint(x: pointX, y: pointY)
        }
    }
    
    public override func destroy() {
        wrappedBehavior.destroy()
        super.destroy()
    }
}
