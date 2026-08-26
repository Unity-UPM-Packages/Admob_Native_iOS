//
//  NativeHalfScreenMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Half-Screen Media (50% màn hình, nửa còn lại trong suốt cho phép touch xuyên qua).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_halfscreen_media.xml & res/layout-land/native_halfscreen_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeHalfScreenMediaLayoutView: BaseNativeAdLayoutView {
    
    // Card quảng cáo chiếm 50% diện tích (màn dọc: 50% dưới, màn ngang: 50% trái)
    private let adCardView = UIView()
    
    // Cụm thông tin Text
    private let textStack = UIStackView()
    private let titleRow = UIStackView()
    
    // Container chứa Circular Countdown
    private let countdownContainer = UIView()
    
    // Aspect ratio constraints cho MediaView (Màn dọc: 4:3, Màn ngang: 16:9)
    private var mediaPortraitRatioConstraint: NSLayoutConstraint?
    private var mediaLandscapeRatioConstraint: NSLayoutConstraint?
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = false // Dùng Circular Countdown
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Cho phép touch xuyên qua phần nửa màn hình trống để tương tác với Game/App bên dưới
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
    public override func setupLayout() {
        backgroundColor = .clear // Trong suốt nửa còn lại
        
        // 1. Khung Card Quảng Cáo (#0E2139)
        adCardView.translatesAutoresizingMaskIntoConstraints = false
        adCardView.backgroundColor = UIColor(hex: "#0E2139")
        adCardView.clipsToBounds = true
        addSubview(adCardView)
        
        // 2. MediaView (Background darker_gray, bo góc 6pt)
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMediaView.contentMode = .scaleAspectFit
        adMediaView.backgroundColor = UIColor(hex: "#808080")
        adMediaView.layer.cornerRadius = 6
        adMediaView.clipsToBounds = true
        adCardView.addSubview(adMediaView)
        
        // 3. Circular Countdown ở góc trên bên trái MediaView
        countdownContainer.translatesAutoresizingMaskIntoConstraints = false
        countdownContainer.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        countdownContainer.layer.cornerRadius = 14
        countdownContainer.clipsToBounds = true
        adCardView.addSubview(countdownContainer)
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = .white
        countdownLbl.font = UIFont.boldSystemFont(ofSize: 12)
        countdownLbl.textAlignment = .center
        countdownContainer.addSubview(countdownLbl)
        
        // 4. Nút Close (X) ở góc trên bên phải MediaView
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        adCardView.addSubview(closeButton)
        
        // 5. Cụm Text
        titleRow.translatesAutoresizingMaskIntoConstraints = false
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 6
        
        // Nhãn Ad màu vàng chữ nâu
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        // Headline chữ trắng
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Advertiser chữ xám (#B0BEC5)
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B0BEC5")
        advertiserLbl.font = UIFont.systemFont(ofSize: 12)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 3
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(advertiserLbl)
        adCardView.addSubview(textStack)
        
        // 6. Nút CTA xanh dương (#1A73E8)
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        adCardView.addSubview(callToActionBtn)
        
        // Dynamic Aspect Ratio Constraints cho MediaView
        mediaPortraitRatioConstraint = adMediaView.widthAnchor.constraint(equalTo: adMediaView.heightAnchor, multiplier: 4.0 / 3.0)
        mediaLandscapeRatioConstraint = adMediaView.widthAnchor.constraint(equalTo: adMediaView.heightAnchor, multiplier: 16.0 / 9.0)
        
        // Base Constraints
        NSLayoutConstraint.activate([
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Countdown container
            countdownContainer.widthAnchor.constraint(equalToConstant: 28),
            countdownContainer.heightAnchor.constraint(equalToConstant: 28),
            countdownContainer.topAnchor.constraint(equalTo: adMediaView.topAnchor, constant: 8),
            countdownContainer.leadingAnchor.constraint(equalTo: adMediaView.leadingAnchor, constant: 8),
            
            countdownLbl.centerXAnchor.constraint(equalTo: countdownContainer.centerXAnchor),
            countdownLbl.centerYAnchor.constraint(equalTo: countdownContainer.centerYAnchor),
            
            // Close button đè trên góc phải MediaView
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.topAnchor.constraint(equalTo: adMediaView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: adMediaView.trailingAnchor, constant: -8)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Chiếm 50% Nửa Dưới)
        // -------------------------------------------------------------
        portraitConstraints = [
            adCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adCardView.topAnchor.constraint(equalTo: centerYAnchor),
            
            adMediaView.topAnchor.constraint(equalTo: adCardView.topAnchor, constant: 14),
            adMediaView.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            adMediaView.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            adMediaView.bottomAnchor.constraint(lessThanOrEqualTo: textStack.topAnchor, constant: -10),
            
            textStack.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: callToActionBtn.topAnchor, constant: -10),
            
            callToActionBtn.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            callToActionBtn.bottomAnchor.constraint(equalTo: adCardView.bottomAnchor, constant: -16),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Chiếm 50% Nửa Trái)
        // -------------------------------------------------------------
        landscapeConstraints = [
            adCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardView.trailingAnchor.constraint(equalTo: centerXAnchor),
            adCardView.topAnchor.constraint(equalTo: topAnchor),
            adCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            adMediaView.topAnchor.constraint(equalTo: adCardView.topAnchor, constant: 14),
            adMediaView.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            adMediaView.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            adMediaView.bottomAnchor.constraint(lessThanOrEqualTo: textStack.topAnchor, constant: -10),
            
            textStack.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: callToActionBtn.topAnchor, constant: -10),
            
            callToActionBtn.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            callToActionBtn.bottomAnchor.constraint(equalTo: adCardView.bottomAnchor, constant: -16),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
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
        mediaPortraitRatioConstraint?.isActive = false
        mediaLandscapeRatioConstraint?.isActive = false
        
        if isLandscape {
            mediaLandscapeRatioConstraint?.isActive = true
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            mediaPortraitRatioConstraint?.isActive = true
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        adCardView.bringSubviewToFront(countdownContainer)
        adCardView.bringSubviewToFront(closeButton)
    }
}
