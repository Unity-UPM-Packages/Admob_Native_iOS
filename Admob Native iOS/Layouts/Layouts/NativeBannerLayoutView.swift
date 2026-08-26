//
//  NativeBannerLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Banner đính cạnh dưới màn hình (cao 60pt), phần còn lại trong suốt cho phép tương tác Game/App.
//  Nền #0E2139 trong suốt 80%, CTA màu #C9FF23.
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_banner.xml & res/layout-land/native_banner.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeBannerLayoutView: BaseNativeAdLayoutView {
    
    // Khung chứa nội dung Banner (đính ở đáy màn hình, cao 60pt)
    private let bannerContainerView = UIView()
    
    // Cụm Text màn dọc (2 tầng: Dòng 1 [Ad] + Headline, Dòng 2 Advertiser)
    private let portraitTextStack = UIStackView()
    private let portraitTitleRow = UIStackView()
    
    // Cụm Text màn ngang
    private let landscapeTitleGroup = UIStackView()
    private let landscapeGuideline = UILayoutGuide() // Trục phân chia 40% như Guideline của Android
    
    private var lastAppliedIsLandscape: Bool?
    
    public init(layoutName: String = "native_banner") {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Cho phép touch xuyên qua phần màn hình phía trên Banner để tương tác với Game/App
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
    public override func setupLayout() {
        backgroundColor = .clear
        self.mediaView = nil
        
        // 1. Banner Container (Màu #0E2139 trong suốt 80%, đính sát đáy, cao 60pt)
        bannerContainerView.translatesAutoresizingMaskIntoConstraints = false
        bannerContainerView.backgroundColor = UIColor(hex: "#0E2139").withAlphaComponent(0.8)
        bannerContainerView.clipsToBounds = true
        addSubview(bannerContainerView)
        
        // Trục phân chia 40% chiều rộng giống hệt layout-land của Android
        bannerContainerView.addLayoutGuide(landscapeGuideline)
        
        // 2. Icon ứng dụng bên trái
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.layer.cornerRadius = 6
        iconImgView.clipsToBounds = true
        bannerContainerView.addSubview(iconImgView)
        
        // 3. Nhãn Ad màu vàng chữ nâu
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        // 4. Headline (chữ trắng/xám sáng in đậm)
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 14)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // 5. Advertiser (chữ xám #B6BCC3)
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B6BCC3")
        advertiserLbl.font = UIFont.systemFont(ofSize: 12)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        // 6. Cấu hình Cụm Text Màn Dọc
        portraitTitleRow.translatesAutoresizingMaskIntoConstraints = false
        portraitTitleRow.axis = .horizontal
        portraitTitleRow.alignment = .center
        portraitTitleRow.spacing = 6
        portraitTitleRow.addArrangedSubview(adBadgeLbl)
        portraitTitleRow.addArrangedSubview(headlineLbl)
        
        portraitTextStack.translatesAutoresizingMaskIntoConstraints = false
        portraitTextStack.axis = .vertical
        portraitTextStack.alignment = .leading
        portraitTextStack.spacing = 3
        portraitTextStack.addArrangedSubview(portraitTitleRow)
        portraitTextStack.addArrangedSubview(advertiserLbl)
        bannerContainerView.addSubview(portraitTextStack)
        
        // 7. Cấu hình Cụm Title Màn Ngang ([Ad] + Headline)
        landscapeTitleGroup.translatesAutoresizingMaskIntoConstraints = false
        landscapeTitleGroup.axis = .horizontal
        landscapeTitleGroup.alignment = .center
        landscapeTitleGroup.spacing = 6
        landscapeTitleGroup.addArrangedSubview(adBadgeLbl)
        landscapeTitleGroup.addArrangedSubview(headlineLbl)
        
        // 8. Nút CTA xanh dương (#1A73E8, chữ trắng)
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#1A73E8")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        bannerContainerView.addSubview(callToActionBtn)
        
        // Base Constraints cố định: Banner luôn đính sát đáy với chiều cao chuẩn 60pt
        NSLayoutConstraint.activate([
            bannerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bannerContainerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Trục Guideline 40% chiều rộng
            landscapeGuideline.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor),
            landscapeGuideline.topAnchor.constraint(equalTo: bannerContainerView.topAnchor),
            landscapeGuideline.bottomAnchor.constraint(equalTo: bannerContainerView.bottomAnchor),
            landscapeGuideline.widthAnchor.constraint(equalTo: bannerContainerView.widthAnchor, multiplier: 0.40),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            callToActionBtn.trailingAnchor.constraint(equalTo: bannerContainerView.trailingAnchor, constant: -10),
            callToActionBtn.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc)
        // Icon (46x46) -> Cụm Text 2 tầng -> CTA (120pt)
        // -------------------------------------------------------------
        portraitConstraints = [
            iconImgView.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor, constant: 8),
            iconImgView.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            iconImgView.widthAnchor.constraint(equalToConstant: 46),
            iconImgView.heightAnchor.constraint(equalToConstant: 46),
            
            portraitTextStack.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 8),
            portraitTextStack.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -8),
            portraitTextStack.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Phân chia chuẩn theo Guideline 40% Android)
        // Khu vực 1 (0 -> 40%): Icon (38x38) + [Ad + Headline]
        // Khu vực 2 (40% -> CTA): Advertiser
        // -------------------------------------------------------------
        landscapeConstraints = [
            iconImgView.leadingAnchor.constraint(equalTo: bannerContainerView.leadingAnchor, constant: 8),
            iconImgView.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            iconImgView.widthAnchor.constraint(equalToConstant: 38),
            iconImgView.heightAnchor.constraint(equalToConstant: 38),
            
            landscapeTitleGroup.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 8),
            landscapeTitleGroup.trailingAnchor.constraint(lessThanOrEqualTo: landscapeGuideline.trailingAnchor, constant: -8),
            landscapeTitleGroup.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            
            advertiserLbl.leadingAnchor.constraint(equalTo: landscapeGuideline.trailingAnchor, constant: 8),
            advertiserLbl.trailingAnchor.constraint(lessThanOrEqualTo: callToActionBtn.leadingAnchor, constant: -10),
            advertiserLbl.centerYAnchor.constraint(equalTo: bannerContainerView.centerYAnchor),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: 130)
        ]
        
        updateOrientationConstraints()
    }
    
    public override func updateOrientationConstraints() {
        guard bounds.width > 0 && bounds.height > 0 else { return }
        let isLandscape = bounds.width > bounds.height
        
        if lastAppliedIsLandscape == isLandscape { return }
        lastAppliedIsLandscape = isLandscape
        
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        
        if isLandscape {
            portraitTextStack.removeFromSuperview()
            portraitTitleRow.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            landscapeTitleGroup.addArrangedSubview(adBadgeLbl)
            landscapeTitleGroup.addArrangedSubview(headlineLbl)
            bannerContainerView.addSubview(landscapeTitleGroup)
            bannerContainerView.addSubview(advertiserLbl)
            
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            landscapeTitleGroup.removeFromSuperview()
            landscapeTitleGroup.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            portraitTitleRow.addArrangedSubview(adBadgeLbl)
            portraitTitleRow.addArrangedSubview(headlineLbl)
            portraitTextStack.addArrangedSubview(portraitTitleRow)
            portraitTextStack.addArrangedSubview(advertiserLbl)
            bannerContainerView.addSubview(portraitTextStack)
            
            NSLayoutConstraint.activate(portraitConstraints)
        }
    }
    
    public override func populate(nativeAd: GADNativeAd) {
        self.mediaView = nil
        self.imageView = nil
        super.populate(nativeAd: nativeAd)
    }
}
