//
//  NativeInterLayoutView.swift
//  Admob Native iOS
//
//  Layout Interstitial toàn màn hình - Ánh xạ 1:1 chuẩn xác với Android native_inter_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeInterLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    private let isSplitVariant: Bool
    
    // Subviews đặc thù cho Native Interstitial
    private let topCardView = UIView()
    private let topDividerView = UIView()
    private let bottomCardView = UIView()
    private let bottomDividerView = UIView()
    
    public init(layoutName: String) {
        self.isNoMediaVariant = layoutName.contains("no_media")
        self.isSplitVariant = layoutName.contains("_2")
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        self.isNoMediaVariant = false
        self.isSplitVariant = false
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .gntBgDark
        
        // 1. Progress Bar (Thanh đếm ngược màu vàng sát mép trên màn hình)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .gntAdBadgeYellow
        progressBar.trackTintColor = .clear
        addSubview(progressBar)
        
        // 2. Top Card (Chứa nhãn Ad, Headline, Advertiser và Close Button ở màn dọc)
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.backgroundColor = .gntBgDark
        addSubview(topCardView)
        
        topCardView.addSubview(adBadgeLbl)
        topCardView.addSubview(headlineLbl)
        topCardView.addSubview(advertiserLbl)
        
        // Close Button
        addSubview(closeButton)
        
        // Top Divider (#505763)
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = .gntBorderDark
        addSubview(topDividerView)
        
        // 3. Media View / Image View (Chiếm trọn không gian giữa)
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        mediaOrImage.translatesAutoresizingMaskIntoConstraints = false
        mediaOrImage.contentMode = .scaleAspectFit
        addSubview(mediaOrImage)
        
        // Bottom Divider (#505763)
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = .gntBorderDark
        addSubview(bottomDividerView)
        
        // 4. Bottom Card (Chứa nút CTA tràn viền ở màn dọc, hoặc Icon + Text + CTA ở màn ngang)
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = .gntBgDark
        addSubview(bottomCardView)
        
        // Subviews trong Bottom Card
        bottomCardView.addSubview(iconImgView)
        bottomCardView.addSubview(callToActionBtn)
        
        // Cấu hình style nút CTA màu xanh #1A73E8
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.headlineTextSize)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.layer.borderWidth = 0
        
        // Style Ad Badge màu vàng chữ nâu
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        
        // Style Advertiser màu #B6BCC3
        advertiserLbl.textColor = .gntSecondaryText
        advertiserLbl.font = UIFont.systemFont(ofSize: 12)
        
        // Base Constraints
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            closeButton.widthAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            closeButton.heightAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            iconImgView.widthAnchor.constraint(equalToConstant: 44),
            iconImgView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Khớp Ảnh 1)
        // -------------------------------------------------------------
        portraitConstraints = [
            // Top Card
            topCardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 60),
            
            // Ad Badge ở góc trên bên trái top_card
            adBadgeLbl.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 14),
            adBadgeLbl.topAnchor.constraint(equalTo: topCardView.topAnchor, constant: 14),
            
            // Headline bên cạnh Ad Badge
            headlineLbl.leadingAnchor.constraint(equalTo: adBadgeLbl.trailingAnchor, constant: 8),
            headlineLbl.centerYAnchor.constraint(equalTo: adBadgeLbl.centerYAnchor),
            headlineLbl.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            // Advertiser bên dưới Ad Badge & Headline
            advertiserLbl.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 14),
            advertiserLbl.topAnchor.constraint(equalTo: adBadgeLbl.bottomAnchor, constant: 4),
            advertiserLbl.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            
            // Close Button căn giữa theo chiều dọc của top_card ở góc phải
            closeButton.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -14),
            closeButton.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),
            
            // Top Divider ngay dưới top_card
            topDividerView.topAnchor.constraint(equalTo: topCardView.bottomAnchor),
            
            // Media View ở giữa 2 divider
            mediaOrImage.topAnchor.constraint(equalTo: topDividerView.bottomAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor),
            
            // Bottom Divider ngay trên bottom_card
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            // Bottom Card
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomCardView.heightAnchor.constraint(equalToConstant: 70),
            
            // CTA Button tràn toàn bộ chiều ngang trong bottom_card
            callToActionBtn.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -16),
            callToActionBtn.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Khớp Ảnh 2)
        // -------------------------------------------------------------
        landscapeConstraints = [
            // Top Card ẩn hoặc 0 height ở màn ngang
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 0),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            topDividerView.topAnchor.constraint(equalTo: topAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0),
            
            // Close Button ở góc trên bên phải màn hình
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            // Media View chiếm toàn bộ không gian phía trên
            mediaOrImage.topAnchor.constraint(equalTo: topAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor),
            
            // Bottom Divider
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            // Bottom Card
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.heightAnchor.constraint(equalToConstant: 64),
            
            // Icon ở bên trái bottom_card
            iconImgView.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 16),
            iconImgView.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            
            // Ad Badge cạnh Icon
            adBadgeLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 12),
            adBadgeLbl.topAnchor.constraint(equalTo: iconImgView.topAnchor, constant: 2),
            
            // Headline bên cạnh Ad Badge
            headlineLbl.leadingAnchor.constraint(equalTo: adBadgeLbl.trailingAnchor, constant: 6),
            headlineLbl.centerYAnchor.constraint(equalTo: adBadgeLbl.centerYAnchor),
            headlineLbl.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),
            
            // Advertiser bên dưới
            advertiserLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 12),
            advertiserLbl.topAnchor.constraint(equalTo: adBadgeLbl.bottomAnchor, constant: 4),
            advertiserLbl.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),
            
            // CTA Button ở bên phải bottom_card
            callToActionBtn.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            callToActionBtn.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: 120),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        updateOrientationConstraints()
    }
}
