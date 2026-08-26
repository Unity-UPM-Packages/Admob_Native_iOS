//
//  BaseNativeAdLayoutView.swift
//  Admob Native iOS
//
//  Base GADNativeAdView bằng Pure Vanilla UIKit.
//  Chứa đầy đủ các UI subview, logic bind data NativeAd chuẩn hóa và hỗ trợ chuyển đổi Portrait / Landscape tự động.
//

import UIKit
import GoogleMobileAds

open class BaseNativeAdLayoutView: GADNativeAdView {
    
    // MARK: - Standard AdMob Subviews
    public let cardContainerView = UIView()
    public let adMediaView = GADMediaView()
    public let headlineLbl = UILabel()
    public let bodyLbl = UILabel()
    public let callToActionBtn = UIButton(type: .custom)
    public let iconImgView = UIImageView()
    public let advertiserLbl = UILabel()
    public let storeLbl = UILabel()
    public let priceLbl = UILabel()
    public let mainImgView = UIImageView()
    
    // MARK: - Ad Badge & Decoration Subviews
    public let adBadgeLbl = UILabel()
    public let closeButton = UIButton(type: .custom)
    public let progressBar = UIProgressView(progressViewStyle: .default)
    public let countdownLbl = UILabel()
    public let countdownContainerView = UIView()
    public let circularProgressView = CircularCountdownView()
    public let dividerView = UIView()
    
    // MARK: - Orientation Constraints
    public var portraitConstraints: [NSLayoutConstraint] = []
    public var landscapeConstraints: [NSLayoutConstraint] = []
    private var lastAppliedOrientationIsLandscape: Bool?
    
    // MARK: - Layout Configuration Flags
    public var isLineFill: Bool = false
    public var isRemainingSuffix: Bool = false
    public var onCloseClicked: (() -> Void)?
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseComponents()
        setupLayout()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseComponents()
        setupLayout()
    }
    
    // MARK: - Base Setup
    private func setupBaseComponents() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        // 1. Container
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.backgroundColor = .gntCardDark
        cardContainerView.layer.cornerRadius = 8
        cardContainerView.clipsToBounds = true
        
        // 2. Media & Images
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMediaView.clipsToBounds = true
        
        mainImgView.translatesAutoresizingMaskIntoConstraints = false
        mainImgView.contentMode = .scaleAspectFit
        mainImgView.clipsToBounds = true
        
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.contentMode = .scaleAspectFill
        iconImgView.layer.cornerRadius = 6
        iconImgView.clipsToBounds = true
        
        // 3. Labels
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.headlineTextSize)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        
        bodyLbl.translatesAutoresizingMaskIntoConstraints = false
        bodyLbl.textColor = .gntGrayD9
        bodyLbl.font = UIFont.systemFont(ofSize: LayoutDimensions.secondaryTextSize)
        bodyLbl.numberOfLines = 1
        bodyLbl.lineBreakMode = .byTruncatingTail
        
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = .gntGrayD9
        advertiserLbl.font = UIFont.systemFont(ofSize: LayoutDimensions.secondaryTextSize)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        // 4. Ad Badge
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.text = "Ad"
        adBadgeLbl.textColor = .black
        adBadgeLbl.textAlignment = .center
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.adBadgeTextSize)
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        
        // 5. CTA Button
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCardDark
        callToActionBtn.layer.borderColor = UIColor.gntBorderDark.cgColor
        callToActionBtn.layer.borderWidth = 1
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.headlineTextSize)
        callToActionBtn.isUserInteractionEnabled = false
        
        // 6. Close Button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(createCloseIcon(), for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        closeButton.layer.cornerRadius = LayoutDimensions.closeBtnSize / 2.0
        closeButton.clipsToBounds = true
        closeButton.isHidden = true // Ẩn mặc định từ đầu để tránh nháy khi load
        closeButton.addTarget(self, action: #selector(handleCloseTapped), for: .touchUpInside)
        
        // 7. Countdown & Progress
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = .gntPillBg
        countdownContainerView.layer.cornerRadius = 12
        countdownContainerView.clipsToBounds = true
        countdownContainerView.isHidden = true
        
        circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        circularProgressView.isHidden = true
        countdownContainerView.addSubview(circularProgressView)
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = .white
        countdownLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.countdownTextSize)
        countdownLbl.textAlignment = .center
        countdownLbl.isHidden = true
        countdownContainerView.addSubview(countdownLbl)
        
        NSLayoutConstraint.activate([
            circularProgressView.topAnchor.constraint(equalTo: countdownContainerView.topAnchor),
            circularProgressView.bottomAnchor.constraint(equalTo: countdownContainerView.bottomAnchor),
            circularProgressView.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor),
            circularProgressView.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor)
        ])
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressViewStyle = .bar
        progressBar.progressImage = BaseNativeAdLayoutView.createSolidColorImage(color: .gntAdBadgeYellow)
        progressBar.trackImage = BaseNativeAdLayoutView.createSolidColorImage(color: UIColor.white.withAlphaComponent(0.3))
        progressBar.layer.cornerRadius = 0
        progressBar.clipsToBounds = true
        progressBar.isHidden = true
        
        // 8. Divider line
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = UIColor(hex: "#505763")
        
        // Link with GADNativeAdView properties
        self.headlineView = headlineLbl
        self.bodyView = bodyLbl
        self.callToActionView = callToActionBtn
        self.iconView = iconImgView
        self.mediaView = adMediaView
        self.advertiserView = advertiserLbl
        self.imageView = mainImgView
    }
    
    // Subclasses override to build UI elements & populate portraitConstraints & landscapeConstraints
    open func setupLayout() {}
    
    // MARK: - Auto Orientation Handling (Portrait <-> Landscape)
    open override func layoutSubviews() {
        super.layoutSubviews()
        progressBar.layer.cornerRadius = 0
        progressBar.layer.sublayers?.forEach { sublayer in
            sublayer.cornerRadius = 0
            sublayer.masksToBounds = true
        }
        updateOrientationConstraints()
    }
    
    public func updateOrientationConstraints() {
        guard bounds.width > 0 && bounds.height > 0 else { return }
        let isLandscape = bounds.width > bounds.height
        
        if lastAppliedOrientationIsLandscape == isLandscape { return }
        lastAppliedOrientationIsLandscape = isLandscape
        
        if isLandscape && !landscapeConstraints.isEmpty {
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else if !portraitConstraints.isEmpty {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }
    
    // MARK: - Populate Data
    open func populate(nativeAd: GADNativeAd) {
        headlineLbl.text = nativeAd.headline
        bodyLbl.text = nativeAd.body
        callToActionBtn.setTitle(nativeAd.callToAction, for: .normal)
        
        if let icon = nativeAd.icon {
            iconImgView.image = icon.image
            iconImgView.isHidden = false
        } else {
            iconImgView.isHidden = true
        }
        
        if let advertiser = nativeAd.advertiser {
            advertiserLbl.text = advertiser
            advertiserLbl.isHidden = false
        } else {
            advertiserLbl.isHidden = true
        }
        
        if nativeAd.mediaContent.hasVideoContent || nativeAd.mediaContent.aspectRatio > 0 {
            adMediaView.mediaContent = nativeAd.mediaContent
            adMediaView.isHidden = false
        } else if let images = nativeAd.images, let firstImage = images.first {
            mainImgView.image = firstImage.image
            mainImgView.isHidden = false
        }
        
        self.nativeAd = nativeAd
    }
    
    @objc private func handleCloseTapped() {
        onCloseClicked?()
    }
    
    public static func createSolidColorImage(color: UIColor) -> UIImage? {
        let size = CGSize(width: 2, height: 2)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setFillColor(color.cgColor)
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func createCloseIcon() -> UIImage? {
        let size = CGSize(width: 28, height: 28)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        
        // 1. Vòng tròn nền xám (#5A5A5A) kèm viền sáng (#8E9DAE)
        let circleRect = CGRect(x: 1.5, y: 1.5, width: 25, height: 25)
        ctx.setFillColor(UIColor(hex: "#5A5A5A").cgColor)
        ctx.fillEllipse(in: circleRect)
        
        ctx.setStrokeColor(UIColor(hex: "#8E9DAE").cgColor)
        ctx.setLineWidth(1.0)
        ctx.strokeEllipse(in: circleRect)
        
        // 2. Viền sáng chữ X (#8E9DAE)
        ctx.setStrokeColor(UIColor(hex: "#8E9DAE").cgColor)
        ctx.setLineWidth(4.0)
        ctx.setLineCap(.round)
        ctx.move(to: CGPoint(x: 9, y: 9))
        ctx.addLine(to: CGPoint(x: 19, y: 19))
        ctx.move(to: CGPoint(x: 19, y: 9))
        ctx.addLine(to: CGPoint(x: 9, y: 19))
        ctx.strokePath()
        
        // 3. Thân chữ X màu tối bên trong (#1C1C1C)
        ctx.setStrokeColor(UIColor(hex: "#1C1C1C").cgColor)
        ctx.setLineWidth(2.4)
        ctx.setLineCap(.round)
        ctx.move(to: CGPoint(x: 9, y: 9))
        ctx.addLine(to: CGPoint(x: 19, y: 19))
        ctx.move(to: CGPoint(x: 19, y: 9))
        ctx.addLine(to: CGPoint(x: 9, y: 19))
        ctx.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
