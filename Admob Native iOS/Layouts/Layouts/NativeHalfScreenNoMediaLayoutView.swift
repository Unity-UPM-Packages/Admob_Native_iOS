//
//  NativeHalfScreenNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Half-Screen No-Media (50% màn hình, Icon lớn căn giữa, nửa còn lại trong suốt).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_halfscreen_no_media.xml & res/layout-land/native_halfscreen_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeHalfScreenNoMediaLayoutView: BaseNativeAdLayoutView {
    
    // Card quảng cáo chiếm 50% diện tích (màn dọc: 50% dưới, màn ngang: 50% trái)
    private let adCardView = UIView()
    
    // Icon lớn 120pt căn giữa
    public let largeIconImgView = UIImageView()
    
    // Cụm thông tin Text
    private let textStack = UIStackView()
    private let subRow = UIStackView()
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = false
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
        
        // 2. Circular Countdown ở góc trên bên trái (Dùng countdownContainerView & circularProgressView từ Base)
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = .clear
        countdownContainerView.isHidden = true
        circularProgressView.isHidden = false
        circularProgressView.progressColor = .white
        countdownLbl.font = UIFont.boldSystemFont(ofSize: 12)
        countdownLbl.textColor = .white
        adCardView.addSubview(countdownContainerView)
        
        // 3. Nút Close (X) ở góc trên bên phải
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        adCardView.addSubview(closeButton)
        
        // 4. Cụm Text ở phía trên giữa nút đếm giờ và nút đóng
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        subRow.translatesAutoresizingMaskIntoConstraints = false
        subRow.axis = .horizontal
        subRow.alignment = .center
        subRow.spacing = 6
        
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B0BEC5")
        advertiserLbl.font = UIFont.systemFont(ofSize: 12)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        subRow.addArrangedSubview(adBadgeLbl)
        subRow.addArrangedSubview(advertiserLbl)
        
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.alignment = .leading
        textStack.spacing = 3
        textStack.addArrangedSubview(headlineLbl)
        textStack.addArrangedSubview(subRow)
        adCardView.addSubview(textStack)
        
        // 5. Icon quảng cáo lớn (120x120pt) căn giữa
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 20
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        adCardView.addSubview(largeIconImgView)
        
        // 6. Nút CTA xanh dương (#1A73E8)
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        adCardView.addSubview(callToActionBtn)
        
        // Base Constraints
        NSLayoutConstraint.activate([
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Countdown container (24x24dp)
            countdownContainerView.widthAnchor.constraint(equalToConstant: 24),
            countdownContainerView.heightAnchor.constraint(equalToConstant: 24),
            countdownContainerView.topAnchor.constraint(equalTo: adCardView.topAnchor, constant: 16),
            countdownContainerView.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            
            // Close button (24x24dp)
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.topAnchor.constraint(equalTo: adCardView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            
            // Cụm Text căn ngang hàng với countdown và close button
            textStack.leadingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: 10),
            textStack.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -10),
            textStack.centerYAnchor.constraint(equalTo: countdownContainerView.centerYAnchor),
            
            // Icon lớn căn giữa
            largeIconImgView.centerXAnchor.constraint(equalTo: adCardView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: adCardView.centerYAnchor, constant: 4),
            largeIconImgView.widthAnchor.constraint(equalToConstant: 120),
            largeIconImgView.heightAnchor.constraint(equalToConstant: 120),
            
            // CTA Button ở dưới cùng
            callToActionBtn.leadingAnchor.constraint(equalTo: adCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: adCardView.trailingAnchor, constant: -16),
            callToActionBtn.bottomAnchor.constraint(equalTo: adCardView.bottomAnchor, constant: -16),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Chiếm 50% Nửa Dưới)
        // -------------------------------------------------------------
        portraitConstraints = [
            adCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            adCardView.topAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Chiếm 50% Nửa Trái)
        // -------------------------------------------------------------
        landscapeConstraints = [
            adCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adCardView.trailingAnchor.constraint(equalTo: centerXAnchor),
            adCardView.topAnchor.constraint(equalTo: topAnchor),
            adCardView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        
        adCardView.bringSubviewToFront(countdownContainerView)
        adCardView.bringSubviewToFront(closeButton)
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
