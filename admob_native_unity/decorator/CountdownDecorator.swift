import Foundation
import UIKit
import GoogleMobileAds

@objc public class CountdownDecorator: BaseShowBehavior {
    
    private var wrappedBehavior: BaseShowBehavior?
    private let initialDelaySeconds: TimeInterval
    private let countdownDurationSeconds: TimeInterval
    private let closeButtonDelaySeconds: TimeInterval
    
    private var initialDelayTimer: Timer?
    private var countdownTimer: Timer?
    private var closeButtonDelayTimer: Timer?
    private weak var progressContainer: UIView?
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var countdownStartTime: Date?
    
    private var countdownRemainingSeconds: Int = 0
    
    private weak var closeButton: UIImageView?
    private weak var countdownLabel: UILabel?
    private weak var callbacks: NativeAdCallbacks?
    
    private let TAG_CLOSE_BUTTON = 110
    private let TAG_COUNTDOWN_TEXT = 111
    private let TAG_PROGRESS_BAR = 112
    
    public init(wrappedBehavior: BaseShowBehavior,
         initialDelay: Float,
         countdownDuration: Float,
         closeButtonDelay: Float) {
        self.wrappedBehavior = wrappedBehavior
        self.initialDelaySeconds = TimeInterval(initialDelay)
        self.countdownDurationSeconds = TimeInterval(countdownDuration)
        self.closeButtonDelaySeconds = TimeInterval(closeButtonDelay)
        super.init()
    }
    
    public override func show(viewController: UIViewController,
                       nativeAd: GADNativeAd,
                       layoutName: String,
                       callbacks: NativeAdCallbacks) {
        self.callbacks = callbacks
        
        guard let wrappedBehavior = wrappedBehavior else {
            print("⚠️ CountdownDecorator: wrappedBehavior is nil")
            return
        }
        
        wrappedBehavior.show(viewController: viewController,
                            nativeAd: nativeAd,
                            layoutName: layoutName,
                            callbacks: callbacks)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self,
                  let rootView = self.wrappedBehavior?.getRootView() else { return }
            self.startCloseLogic(rootView: rootView, callbacks: callbacks)
        }
    }
    
    public override func destroy() {
        cancelAllTimers()

        progressLayer.removeFromSuperlayer()
        backgroundLayer.removeFromSuperlayer()
        
        wrappedBehavior?.destroy()
        wrappedBehavior = nil
    }
    
    private func startCloseLogic(rootView: UIView, callbacks: NativeAdCallbacks) {
        closeButton = rootView.viewWithTag(TAG_CLOSE_BUTTON) as? UIImageView
        progressContainer = rootView.viewWithTag(TAG_PROGRESS_BAR) as? UIView
        countdownLabel = rootView.viewWithTag(TAG_COUNTDOWN_TEXT) as? UILabel

        progressLayer.removeFromSuperlayer()
        backgroundLayer.removeFromSuperlayer()
        
        cancelAllTimers()
        
        closeButton?.isHidden = true
        countdownLabel?.isHidden = true
        closeButton?.isUserInteractionEnabled = false
        
        if let closeButton = closeButton {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCloseButtonTapped))
            closeButton.addGestureRecognizer(tapGesture)
        }
        
        startInitialDelayTimer()
    }
    
    private func startInitialDelayTimer() {
        let interval = TimeInterval(initialDelaySeconds)
        
        initialDelayTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.startMainCountdown()
        }
    }

    private func updateCountdownUI(elapsedTime: TimeInterval) {
        let timeRemaining = self.countdownDurationSeconds - elapsedTime
        
        let secondsRemaining = Int(ceil(timeRemaining))
        if countdownLabel?.text != "\(secondsRemaining)" {
            countdownLabel?.text = "\(secondsRemaining)"
        }
        
        let progress = timeRemaining / self.countdownDurationSeconds
        progressLayer.strokeEnd = CGFloat(progress)
    }

    private func setupProgressLayers() {
        guard let container = progressContainer else { return }

        let center = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        let radius = min(container.bounds.width, container.bounds.height) / 2 - 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + (2 * .pi)

        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 4.0
        container.layer.addSublayer(backgroundLayer)

        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 4.0
        progressLayer.strokeEnd = 1.0 // Ban đầu đầy 100%
        container.layer.addSublayer(progressLayer)
    }
    
    private func startMainCountdown() {
        progressContainer?.isHidden = false
        countdownLabel?.isHidden = false
        closeButton?.isHidden = true
        
        countdownRemainingSeconds = Int(countdownDurationSeconds)

        setupProgressLayers()

        countdownStartTime = Date()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            let elapsedTime = Date().timeIntervalSince(self.countdownStartTime ?? Date())

            if elapsedTime >= self.countdownDurationSeconds {
                progressContainer?.isHidden = true
                timer.invalidate()
                self.startCloseButtonDelay()
                return
            }
        
            self.updateCountdownUI(elapsedTime: elapsedTime)
        }
    }
    
    private func startCloseButtonDelay() {
        countdownLabel?.isHidden = true
        closeButton?.isHidden = false
        closeButton?.isUserInteractionEnabled = false // Chưa cho click
        
        
        let interval = TimeInterval(closeButtonDelaySeconds)
        
        closeButtonDelayTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.closeButton?.isUserInteractionEnabled = true
        }
    }
    
    private func cancelAllTimers() {
        initialDelayTimer?.invalidate()
        initialDelayTimer = nil
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        
        closeButtonDelayTimer?.invalidate()
        closeButtonDelayTimer = nil
    }
    
    @objc private func onCloseButtonTapped() {
        guard closeButton?.isUserInteractionEnabled == true else {
            print("⚠️ Close button tapped but not yet enabled")
            return
        }
        
        print("👆 Close button tapped - Destroying ad")
        callbacks?.onAdClosed()
        destroy()
    }
    
    public override func getRootView() -> UIView? {
        return wrappedBehavior?.getRootView()
    }
}
