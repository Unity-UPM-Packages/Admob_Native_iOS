import Foundation
import UIKit
import GoogleMobileAds

@objc public class PositionDecorator: BaseShowBehavior {
    
    private var wrappedBehavior: BaseShowBehavior?
    private let positionX: Int
    private let positionY: Int
    
    public init(wrappedBehavior: BaseShowBehavior,
         x: Int,
         y: Int) {
        self.wrappedBehavior = wrappedBehavior
        self.positionX = x
        self.positionY = y
        super.init()
    }
    
    public override func show(viewController: UIViewController,
                       nativeAd: GADNativeAd,
                       layoutName: String,
                       callbacks: NativeAdCallbacks) {
        guard let wrappedBehavior = wrappedBehavior else {
            print("⚠️ PositionDecorator: wrappedBehavior is nil")
            return
        }
        
        wrappedBehavior.show(viewController: viewController,
                            nativeAd: nativeAd,
                            layoutName: layoutName,
                            callbacks: callbacks)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let rootView = self.wrappedBehavior?.getRootView() else { return }
            self.applyPosition(to: rootView)
        }
    }
    
    public override func destroy() {
        wrappedBehavior?.destroy()
        wrappedBehavior = nil
    }
    
    private func applyPosition(to view: UIView) {
        guard let superview = view.superview else {
            print("⚠️ PositionDecorator: Cannot apply position - no superview")
            return
        }
        
        UIView.performWithoutAnimation {
            let positionConstraints = superview.constraints.filter { constraint in
                guard let firstItem = constraint.firstItem as? UIView,
                      let secondItem = constraint.secondItem as? UIView else {
                    return false
                }
                
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
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let newConstraints = [
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: CGFloat(positionX)),
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: CGFloat(positionY))
            ]
            
            NSLayoutConstraint.activate(newConstraints)
            
            superview.layoutIfNeeded()
            
            print("✅ PositionDecorator: Applied position (\(positionX), \(positionY))")
        }
    }
    
    
    public override func getRootView() -> UIView? {
        return wrappedBehavior?.getRootView()
    }
}
