//
//  CircularCountdownView.swift
//  Admob Native iOS
//
//  Custom View vẽ vòng tròn đếm ngược (Circular Progress Ring) dạng fill/stroke mất dần
//  Ánh xạ 1:1 với drawable/circular_progress_bar.xml của Android.
//

import UIKit

public final class CircularCountdownView: UIView {
    
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    public var trackColor: UIColor = UIColor.white.withAlphaComponent(0.2) {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    public var progressColor: UIColor = UIColor(hex: "#7F7F7F") {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    public var ringLineWidth: CGFloat = 2.5 {
        didSet {
            trackLayer.lineWidth = ringLineWidth
            progressLayer.lineWidth = ringLineWidth
            setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = .clear
        
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = ringLineWidth
        layer.addSublayer(trackLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = ringLineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1.0
        layer.addSublayer(progressLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        trackLayer.frame = bounds
        progressLayer.frame = bounds
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(0, (min(bounds.width, bounds.height) - ringLineWidth) / 2)
        // Bắt đầu từ đỉnh trên cùng (-90 độ)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
    }
    
    public func setProgress(_ progress: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = CGFloat(max(0.0, min(1.0, progress)))
        CATransaction.commit()
    }
}
