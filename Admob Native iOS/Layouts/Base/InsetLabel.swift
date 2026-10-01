//
//  InsetLabel.swift
//  Admob Native iOS
//
//  UILabel có khoảng đệm bên trong (tương đương padding của TextView bên Android):
//  khung view (vùng click) giữ nguyên, chỉ vùng vẽ chữ bị thu lại nên chữ dài sẽ bị cắt "..." sớm hơn.
//

import UIKit

public final class InsetLabel: UILabel {

    public var contentInsets: UIEdgeInsets = .zero {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInsets))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }

    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = super.textRect(forBounds: bounds.inset(by: contentInsets), limitedToNumberOfLines: numberOfLines)
        let inverted = UIEdgeInsets(top: -contentInsets.top, left: -contentInsets.left, bottom: -contentInsets.bottom, right: -contentInsets.right)
        return insetRect.inset(by: inverted)
    }
}
