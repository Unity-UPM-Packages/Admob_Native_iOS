//
//  AdmobNativeTimer.swift
//  Admob Native iOS
//
//  Bộ đếm thời gian mượt mà thay thế SonicCountDownTimer trên iOS.
//  Sử dụng Timer gắn vào RunLoop mode .common để tránh bị khựng/delay khi người dùng vuốt/chạm màn hình.
//

import Foundation

public final class AdmobNativeTimer {
    private var timer: Timer?
    private var durationMillis: Double
    private var intervalMillis: Double
    private var timeRemainingMillis: Double
    
    public var onTick: ((_ timeRemainingMillis: Double) -> Void)?
    public var onFinish: (() -> Void)?
    
    public init(durationMillis: Double, intervalMillis: Double = 16.0) {
        self.durationMillis = durationMillis
        self.intervalMillis = intervalMillis
        self.timeRemainingMillis = durationMillis
    }
    
    public func start() {
        cancel()
        
        if durationMillis <= 0 {
            onFinish?()
            return
        }
        
        timeRemainingMillis = durationMillis
        let intervalSeconds = intervalMillis / 1000.0
        
        let newTimer = Timer(timeInterval: intervalSeconds, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemainingMillis -= self.intervalMillis
            
            if self.timeRemainingMillis <= 0 {
                self.cancel()
                self.onTick?(0)
                self.onFinish?()
            } else {
                self.onTick?(self.timeRemainingMillis)
            }
        }
        
        // Gắn vào RunLoop mode .common để đảm bảo không bị dừng khi có touch event trên UI
        RunLoop.main.add(newTimer, forMode: .common)
        self.timer = newTimer
    }
    
    public func cancel() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        cancel()
    }
}
