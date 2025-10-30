import Foundation
import UIKit
import GoogleMobileAds

/// Decorator thêm chức năng positioning vào BaseShowBehavior.
/// Tương đương với PositionDecorator.kt
@objc public class PositionDecorator: BaseShowBehavior {
    
    private var wrappedBehavior: BaseShowBehavior?  // Changed to var and optional
    private let positionX: Int
    private let positionY: Int
    
    deinit {
        print("🗑️ PositionDecorator: deallocated from memory")
    }
    
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
        print("🗑️ PositionDecorator: Starting destroy...")
        wrappedBehavior?.destroy()
        
        // CRITICAL: Clear reference để break retain cycle
        print("  → Clearing wrappedBehavior reference")
        wrappedBehavior = nil
        print("✅ PositionDecorator: Destroy complete")
    }
    
    // MARK: - Position Logic
    
    private func applyPosition(to view: UIView) {
        guard let superview = view.superview else {
            print("⚠️ PositionDecorator: Cannot apply position - no superview")
            return
        }
        
        // Remove existing constraints
        view.removeConstraints(view.constraints)
        
        // Tạo constraints mới với position cụ thể
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: CGFloat(positionX)),
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: CGFloat(positionY))
        ])
        
        print("✅ PositionDecorator: Applied position (\(positionX), \(positionY))")
    }
    
    // MARK: - Public Accessors
    
    public override func getRootView() -> UIView? {
        return wrappedBehavior?.getRootView()
    }
}
