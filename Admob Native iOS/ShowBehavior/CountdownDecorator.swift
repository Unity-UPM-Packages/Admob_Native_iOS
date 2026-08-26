//
//  CountdownDecorator.swift
//  Admob Native iOS
//
//  Decorator quản lý chu trình 3 pha đếm ngược và trạng thái kích hoạt nút đóng.
//

import UIKit
import GoogleMobileAds

public final class CountdownDecorator: BaseShowBehavior {
    
    private let wrappedBehavior: BaseShowBehavior
    private let initialDelaySeconds: Float
    private let countdownDurationSeconds: Float
    private let closeButtonDelaySeconds: Float
    
    private var initialDelayTimer: AdmobNativeTimer?
    private var countdownTimer: AdmobNativeTimer?
    private var closeButtonDelayTimer: AdmobNativeTimer?
    
    public init(
        wrappedBehavior: BaseShowBehavior,
        initialDelaySeconds: Float,
        countdownDurationSeconds: Float,
        closeButtonDelaySeconds: Float
    ) {
        self.wrappedBehavior = wrappedBehavior
        self.initialDelaySeconds = initialDelaySeconds
        self.countdownDurationSeconds = countdownDurationSeconds
        self.closeButtonDelaySeconds = closeButtonDelaySeconds
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
            
            if let adView = self.currentAdView {
                self.startCloseLogic(adView: adView, callbacks: callbacks, clientPtr: clientPtr)
            }
        }
    }
    
    public override func destroy() {
        cancelAllTimers()
        wrappedBehavior.destroy()
        super.destroy()
    }
    
    private func cancelAllTimers() {
        initialDelayTimer?.cancel()
        initialDelayTimer = nil
        
        countdownTimer?.cancel()
        countdownTimer = nil
        
        closeButtonDelayTimer?.cancel()
        closeButtonDelayTimer = nil
    }
    
    private func startCloseLogic(
        adView: BaseNativeAdLayoutView,
        callbacks: NativeAdCallbacks?,
        clientPtr: UnsafeMutableRawPointer?
    ) {
        cancelAllTimers()
        
        // PHA 1: Trạng thái ban đầu - Ẩn toàn bộ
        adView.closeButton.isHidden = true
        adView.closeButton.alpha = 1.0
        adView.closeButton.isUserInteractionEnabled = false
        
        adView.countdownContainerView.isHidden = true
        adView.progressBar.isHidden = true
        adView.countdownLbl.isHidden = true
        
        let initialDelayMs = Double(initialDelaySeconds * 1000.0)
        
        if initialDelayMs > 0 {
            initialDelayTimer = AdmobNativeTimer(durationMillis: initialDelayMs, intervalMillis: 100)
            initialDelayTimer?.onFinish = { [weak self] in
                self?.startMainCountdown(adView: adView)
            }
            initialDelayTimer?.start()
        } else {
            startMainCountdown(adView: adView)
        }
    }
    
    private func startMainCountdown(adView: BaseNativeAdLayoutView) {
        adView.countdownContainerView.isHidden = adView.isLineFill
        adView.progressBar.isHidden = !adView.isLineFill
        adView.countdownLbl.isHidden = adView.isLineFill
        adView.closeButton.isHidden = true
        adView.closeButton.alpha = 0.5
        adView.closeButton.isUserInteractionEnabled = false
        
        let totalDurationMs = Double(countdownDurationSeconds * 1000.0)
        
        if adView.isLineFill {
            adView.progressBar.progress = 0.0
            adView.circularProgressView.setProgress(0.0)
        } else {
            adView.progressBar.progress = 1.0
            adView.circularProgressView.setProgress(1.0)
        }
        
        countdownTimer = AdmobNativeTimer(durationMillis: totalDurationMs, intervalMillis: 16.0)
        
        countdownTimer?.onTick = { [weak adView] timeRemainingMs in
            guard let adView = adView else { return }
            
            let secondsRemaining = Int(ceil(timeRemainingMs / 1000.0))
            
            // Ở 2 giây cuối: Nút close bắt đầu hiện mờ
            if secondsRemaining <= 2 {
                adView.closeButton.isHidden = false
                adView.closeButton.alpha = 0.5
                adView.closeButton.isUserInteractionEnabled = false
            } else {
                adView.closeButton.isHidden = true
            }
            
            // Cập nhật text đếm ngược
            if adView.isRemainingSuffix {
                adView.countdownLbl.text = "\(secondsRemaining)s remaining..."
            } else {
                adView.countdownLbl.text = "\(secondsRemaining)"
            }
            
            // Cập nhật thanh progress & circular countdown
            let progress: Float
            if adView.isLineFill {
                let elapsedMs = totalDurationMs - timeRemainingMs
                progress = Float(elapsedMs / totalDurationMs)
            } else {
                progress = Float(timeRemainingMs / totalDurationMs)
            }
            adView.progressBar.setProgress(max(0.0, min(1.0, progress)), animated: false)
            adView.circularProgressView.setProgress(max(0.0, min(1.0, progress)))
        }
        
        countdownTimer?.onFinish = { [weak self, weak adView] in
            guard let self = self, let adView = adView else { return }
            if adView.isLineFill {
                adView.progressBar.progress = 1.0
            }
            self.startCloseButtonDelay(adView: adView)
        }
        
        countdownTimer?.start()
    }
    
    private func startCloseButtonDelay(adView: BaseNativeAdLayoutView) {
        // Ẩn text đếm ngược và pill
        adView.countdownLbl.isHidden = true
        adView.countdownContainerView.isHidden = true
        
        // Giữ lại thanh progressBar vàng ở mức 1.0 (không ẩn khi chạy hết giờ)
        if adView.isLineFill {
            adView.progressBar.isHidden = false
            adView.progressBar.progress = 1.0
        } else {
            adView.progressBar.isHidden = true
        }
        
        // Hiện rõ nút close nhưng chưa cho click
        adView.closeButton.isHidden = false
        adView.closeButton.alpha = 1.0
        adView.closeButton.isUserInteractionEnabled = false
        
        let closeDelayMs = Double(closeButtonDelaySeconds * 1000.0)
        
        if closeDelayMs > 0 {
            closeButtonDelayTimer = AdmobNativeTimer(durationMillis: closeDelayMs, intervalMillis: 100)
            closeButtonDelayTimer?.onFinish = { [weak adView] in
                adView?.closeButton.isUserInteractionEnabled = true
            }
            closeButtonDelayTimer?.start()
        } else {
            adView.closeButton.isUserInteractionEnabled = true
        }
    }
}
