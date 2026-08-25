//
//  LayoutDimensions.swift
//  Admob Native iOS
//
//  Quản lý kích thước responsive tự động thích ứng giữa iPhone và iPad.
//

import UIKit

public struct LayoutDimensions {
    public static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // Scale token
    public static var closeBtnSize: CGFloat { isPad ? 40.0 : 28.0 }
    public static var countdownTextSize: CGFloat { isPad ? 16.0 : 12.0 }
    public static var headlineTextSize: CGFloat { isPad ? 20.0 : 15.0 }
    public static var secondaryTextSize: CGFloat { isPad ? 15.0 : 12.0 }
    public static var adBadgeTextSize: CGFloat { isPad ? 14.0 : 10.0 }
    public static var footerHeight: CGFloat { isPad ? 88.0 : 60.0 }
    public static var footerIconSize: CGFloat { isPad ? 52.0 : 36.0 }
    public static var largeIconSize: CGFloat { isPad ? 260.0 : 180.0 }
    public static var ctaWidth: CGFloat { isPad ? 200.0 : 140.0 }
    public static var ctaHeight: CGFloat { isPad ? 54.0 : 40.0 }
}

public extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red, green, blue: CGFloat
        if hexSanitized.count == 6 {
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        } else {
            red = 0; green = 0; blue = 0
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Bảng màu chuẩn dự án (đồng bộ 100% với Android)
    static let gntBgDark = UIColor(hex: "#0B1528")
    static let gntCardDark = UIColor(hex: "#151F31")
    static let gntRewardBgDark = UIColor(hex: "#2F2A2E")
    static let gntGrayD9 = UIColor(hex: "#D9D9D9")
    static let gntGray7F = UIColor(hex: "#7F7F7F")
    static let gntSecondaryText = UIColor(hex: "#B6BCC3")
    static let gntAdBadgeYellow = UIColor(hex: "#F5A623")
    static let gntAdBadgeTextBrown = UIColor(hex: "#5D4037")
    static let gntBgNativeSolid = UIColor(hex: "#0E2139")
    static let gntBgNativeBanner = UIColor(hex: "#0E2139", alpha: 0.85)
    static let gntCtaBlue = UIColor(hex: "#1A73E8")
    static let gntCtaGreen = UIColor(hex: "#34A853")
    static let gntRewardCtaV2 = UIColor(hex: "#3A3539")
    static let gntPillBg = UIColor(hex: "#2B3648")
    static let gntBorderDark = UIColor(hex: "#505763")
}
