//
//  NativeHalfScreenNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Half-Screen No-Media (Chiếm 50% màn hình, không chặn touch ở nửa còn lại, icon lớn căn giữa).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_halfscreen_no_media.xml & res/layout-land/native_halfscreen_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeHalfScreenNoMediaLayoutView: BaseNativeAdLayoutView {
    
    // Khung card quảng cáo (chiếm 50% dưới ở màn dọc, 50% trái ở màn ngang)
    private let adCardContainerView = UIView()
    
    // Header Top: Circular Countdown bên trái, Text ở giữa, Nút Close bên phải
    private let circularCountdownView = UIView()
    private let headerStack = UIStackView()
    private let titleRow = UIStackView()
    private let textStack = UIStackView()
    
    // Icon lớn ở giữa
    public let largeIconImgView = UIImageView()
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = false
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Không chặn thao tác touch ở phần nửa màn hình trong suốt
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return adCardContainerView.frame.contains(point)
    }
    
    public override func setupLayout() {
        backgroundColor = .clear
        
        // 1. Khung card quảng cáo màu #0E2139 (gnt_bg_native_solid)
        adCardContainerView.translatesAutoresizingMaskIntoConstraints = false
        adCardContainerView.backgroundColor = UIColor(hex: "#0E2139")
        adCardContainerView.clipsToBounds = true
        addSubview(adCardContainerView)
        
        // 2. Circular Countdown bên trái góc trên
        circularCountdownView.translatesAutoresizingMaskIntoConstraints = false
        circularCountdownView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        circularCountdownView.layer.borderColor = UIColor(hex: "#7F7F7F").cgColor
        circularCountdownView.layer.borderWidth = 1.5
        circularCountdownView.layer.cornerRadius = 14
        circularCountdownView.clipsToBounds = true
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = .white
        countdownLbl.font = UIFont.boldSystemFont(ofSize: 12)
        countdownLbl.textAlignment = .center
        circularCountdownView.addSubview(countdownLbl)
        adCardContainerView.addSubview(circularCountdownView)
        
        // 3. Nút Close bên phải góc trên
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        adCardContainerView.addSubview(closeButton)
        
        // 4. Cụm Text ở giữa (Headline phía trên, [Ad] + Advertiser ở dưới)
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 16)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        titleRow.translatesAutoresizingMaskIntoConstraints = false
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 6
        
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B0BEC5")
        advertiserLbl.font = UIFont.systemFont(ofSize: 13)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(advertiserLbl)
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 4
        textStack.addArrangedSubview(headlineLbl)
        textStack.addArrangedSubview(titleRow)
        adCardContainerView.addSubview(textStack)
        
        // 5. Icon lớn căn giữa
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 20
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        adCardContainerView.addSubview(largeIconImgView)
        
        // 6. Nút CTA xanh #1A73E8 ở dưới cùng
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#1A73E8")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        adCardContainerView.addSubview(callToActionBtn)
        
        let iconSize: CGFloat = LayoutDimensions.isPad ? 180 : 120
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            circularCountdownView.widthAnchor.constraint(equalToConstant: 28),
            circularCountdownView.heightAnchor.constraint(equalToConstant: 28),
            circularCountdownView.topAnchor.constraint(equalTo: adCardContainerView.topAnchor, constant: 16),
            circularCountdownView.leadingAnchor.constraint(equalTo: adCardContainerView.leadingAnchor, constant: 16),
            
            countdownLbl.centerXAnchor.constraint(equalTo: circularCountdownView.centerXAnchor),
            countdownLbl.centerYAnchor.constraint(equalTo: circularCountdownView.centerYAnchor),
            
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.topAnchor.constraint(equalTo: adCardContainerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: adCardContainerView.trailingAnchor, constant: -16),
            
            textStack.topAnchor.constraint(equalTo: adCardContainerView.topAnchor, constant: 14),
            textStack.leadingAnchor.constraint(equalTo: circularCountdownView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12),
            
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.centerXAnchor.constraint(equalTo: adCardContainerView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: adCardContainerView.centerYAnchor, constant: 10),
            
            callToActionBtn.leadingAnchor.constraint(equalTo: adCardContainerView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: adCardContainerView.trailingAnchor, constant: -16),
            callToActionBtn.bottomAnchor.constraint(equalTo: adCardContainerView.bottomAnchor, constant: -16),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        // PORTRAIT CONSTRAINTS (50% Dưới)
        portraitConstraints = [
            adCardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adCardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adCardContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ]
        
        // LANDSCAPE CONSTRAINTS (50% Trái)
        landscapeConstraints = [
            adCardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardContainerView.topAnchor.constraint(equalTo: topAnchor),
            adCardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adCardContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
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
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        adCardContainerView.bringSubviewToFront(circularCountdownView)
        adCardContainerView.bringSubviewToFront(closeButton)
    }
    
    public override func populate(nativeAd: GADNativeAd) {
        super.populate(nativeAd: nativeAd)
        if let icon = nativeAd.icon {
            largeIconImgView.image = icon.image
            largeIconImgView.isHidden = false
        }
        self.iconView = largeIconImgView
    }
}
