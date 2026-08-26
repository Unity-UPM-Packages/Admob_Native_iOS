//
//  CircularCountdownView.swift
//  Admob Native iOS
//
//  Custom View vẽ vòng tròn đếm ngược (Circular Progress Ring) dạng fill/stroke mất dần
//  Ánh xạ 1:1 với drawable/circular_progress_bar.xml của Android (chỉ có 1 viền ring duy nhất, không có nền mờ phía sau).
//

import UIKit

public final class CircularCountdownView: UIView {
    
    private let progressLayer = CAShapeLayer()
    
    public var progressColor: UIColor = UIColor(hex: "#7F7F7F") {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    public var ringLineWidth: CGFloat = 2.5 {
        didSet {
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
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = ringLineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1.0
        layer.addSublayer(progressLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.frame = bounds
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = max(0, (min(bounds.width, bounds.height) - ringLineWidth) / 2)
        // Bắt đầu từ đỉnh trên cùng (-90 độ / 270 độ như Android)
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        progressLayer.path = path.cgPath
    }
    
    public func setProgress(_ progress: Float) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = CGFloat(max(0.0, min(1.0, progress)))
        CATransaction.commit()
    }
}
