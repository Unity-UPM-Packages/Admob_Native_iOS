//
//  NativeHalfScreenMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Half-Screen Media (Chiếm 50% màn hình, không chặn touch ở nửa còn lại).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_halfscreen_media.xml & res/layout-land/native_halfscreen_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeHalfScreenMediaLayoutView: BaseNativeAdLayoutView {
    
    // Khung card quảng cáo (chiếm 50% dưới ở màn dọc, 50% trái ở màn ngang)
    private let adCardContainerView = UIView()
    
    // Placeholder xám cho MediaView khi xem Canvas hoặc chưa load video
    private let mediaPlaceholderView = UIView()
    
    // Cụm Text
    private let titleRow = UIStackView()
    private let textStack = UIStackView()
    
    // Circular Countdown ở góc trên bên trái của MediaView
    private let circularCountdownView = UIView()
    
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
        
        // 2. MediaView nằm phía trên
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMediaView.contentMode = .scaleAspectFit
        adMediaView.backgroundColor = UIColor(hex: "#9E9E9E")
        adMediaView.layer.cornerRadius = 6
        adMediaView.clipsToBounds = true
        adCardContainerView.addSubview(adMediaView)
        
        // Placeholder hiển thị khối chữ nhật xám #9E9E9E bên trong MediaView
        mediaPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        mediaPlaceholderView.backgroundColor = UIColor(hex: "#9E9E9E")
        mediaPlaceholderView.layer.cornerRadius = 6
        mediaPlaceholderView.clipsToBounds = true
        adMediaView.addSubview(mediaPlaceholderView)
        
        // 3. Circular Countdown ở góc trên bên trái của MediaView
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
        
        // 4. Nút Close X ở góc trên bên phải của MediaView
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        adCardContainerView.addSubview(closeButton)
        
        // 5. Cụm Text ([Ad] vàng, Headline trắng, Advertiser #B0BEC5)
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
        
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 16)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B0BEC5")
        advertiserLbl.font = UIFont.systemFont(ofSize: 13)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 4
        textStack.setContentHuggingPriority(.required, for: .vertical)
        textStack.setContentCompressionResistancePriority(.required, for: .vertical)
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(advertiserLbl)
        adCardContainerView.addSubview(textStack)
        
        // 6. Nút CTA xanh #1A73E8
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#1A73E8")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        callToActionBtn.setContentHuggingPriority(.required, for: .vertical)
        callToActionBtn.setContentCompressionResistancePriority(.required, for: .vertical)
        adCardContainerView.addSubview(callToActionBtn)
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            // Khung Placeholder xám luôn full MediaView
            mediaPlaceholderView.topAnchor.constraint(equalTo: adMediaView.topAnchor),
            mediaPlaceholderView.bottomAnchor.constraint(equalTo: adMediaView.bottomAnchor),
            mediaPlaceholderView.leadingAnchor.constraint(equalTo: adMediaView.leadingAnchor),
            mediaPlaceholderView.trailingAnchor.constraint(equalTo: adMediaView.trailingAnchor),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.topAnchor.constraint(equalTo: adMediaView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: adMediaView.trailingAnchor, constant: -8),
            
            circularCountdownView.widthAnchor.constraint(equalToConstant: 28),
            circularCountdownView.heightAnchor.constraint(equalToConstant: 28),
            circularCountdownView.topAnchor.constraint(equalTo: adMediaView.topAnchor, constant: 8),
            circularCountdownView.leadingAnchor.constraint(equalTo: adMediaView.leadingAnchor, constant: 8),
            
            countdownLbl.centerXAnchor.constraint(equalTo: circularCountdownView.centerXAnchor),
            countdownLbl.centerYAnchor.constraint(equalTo: circularCountdownView.centerYAnchor),
            
            // MediaView chiếm toàn bộ phần trên
            adMediaView.topAnchor.constraint(equalTo: adCardContainerView.topAnchor, constant: 16),
            adMediaView.leadingAnchor.constraint(equalTo: adCardContainerView.leadingAnchor, constant: 16),
            adMediaView.trailingAnchor.constraint(equalTo: adCardContainerView.trailingAnchor, constant: -16),
            adMediaView.bottomAnchor.constraint(equalTo: textStack.topAnchor, constant: -12),
            
            // Cụm Text và Nút CTA ghim ở dưới
            textStack.leadingAnchor.constraint(equalTo: adCardContainerView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: adCardContainerView.trailingAnchor, constant: -16),
            textStack.bottomAnchor.constraint(equalTo: callToActionBtn.topAnchor, constant: -12),
            
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
}
