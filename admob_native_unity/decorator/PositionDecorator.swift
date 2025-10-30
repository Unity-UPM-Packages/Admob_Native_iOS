import Foundation
import UIKit
import GoogleMobileAds

/// Decorator thêm chức năng positioning vào BaseShowBehavior.
/// Tương đương với PositionDecorator.kt
@objc public class PositionDecorator: BaseShowBehavior {
    
    private var wrappedBehavior: BaseShowBehavior?
    private let positionX: Int
    private let positionY: Int
    
    // MARK: - Initialization
    
    public init(wrappedBehavior: BaseShowBehavior,
         x: Int,
         y: Int) {
        self.wrappedBehavior = wrappedBehavior
        self.positionX = x
        self.positionY = y
        super.init()
    }
    
    // MARK: - IShowBehavior Override
    
    public override func show(viewController: UIViewController,
                       nativeAd: GADNativeAd,
                       layoutName: String,
                       callbacks: NativeAdCallbacks) {
        guard let wrappedBehavior = wrappedBehavior else {
            print("⚠️ PositionDecorator: wrappedBehavior is nil")
            return
        }
        
        // Gọi wrapped behavior để hiển thị ad
        wrappedBehavior.show(viewController: viewController,
                            nativeAd: nativeAd,
                            layoutName: layoutName,
                            callbacks: callbacks)
        
        // Đợi một chút để view được add vào hierarchy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self,
                  let rootView = self.wrappedBehavior?.getRootView() else { return }
            self.applyPosition(to: rootView)
        }
    }
    
    public override func destroy() {
        wrappedBehavior?.destroy()
        wrappedBehavior = nil
    }
    
    // MARK: - Position Logic
    
    private func applyPosition(to view: UIView) {
        guard let superview = view.superview else {
            print("⚠️ PositionDecorator: Cannot apply position - no superview")
            return
        }
        
        // Force layout để có frame chính xác
        superview.layoutIfNeeded()
        
        // Find và remove CHỈ position-related constraints (centerX, centerY, leading, trailing, top, bottom)
        // GIỮ LẠI width và height constraints!
        let positionConstraints = superview.constraints.filter { constraint in
            guard let firstItem = constraint.firstItem as? UIView,
                  let secondItem = constraint.secondItem as? UIView else {
                return false
            }
            
            // Chỉ remove constraints liên quan đến position
            if firstItem == view || secondItem == view {
                let attr = constraint.firstAttribute
                return attr == .leading || attr == .trailing || 
                       attr == .left || attr == .right ||
                       attr == .top || attr == .bottom ||
                       attr == .centerX || attr == .centerY
            }
            return false
        }
        
        NSLayoutConstraint.deactivate(positionConstraints)
        print("  → Deactivated \(positionConstraints.count) position constraints")
        
        // Add position constraints mới
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let newConstraints = [
            view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: CGFloat(positionX)),
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: CGFloat(positionY))
        ]
        
        NSLayoutConstraint.activate(newConstraints)
        
        print("✅ PositionDecorator: Applied position (\(positionX), \(positionY))")
    }
    
    // MARK: - Public Accessors
    
    public override func getRootView() -> UIView? {
        return wrappedBehavior?.getRootView()
    }
}
