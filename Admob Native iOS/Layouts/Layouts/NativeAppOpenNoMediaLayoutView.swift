//
//  NativeAppOpenNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout AppOpen No-Media toàn màn hình (Chỉ dùng duy nhất Icon lớn 180pt căn giữa trên nền xám #D9D9D9, không dùng icon bé).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_appopen_no_media.xml & res/layout-land/native_appopen_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeAppOpenNoMediaLayoutView: BaseNativeAdLayoutView {
    
    // Top Bar, Center Icon Container, White Footer Card & Bottom Bar
    private let topBarView = UIView()
    private let bottomBarView = UIView()
    private let footerCardView = UIView()
    private let centerContainerView = UIView()
    
    // Icon lớn 180pt căn giữa thay cho MediaView
    public let largeIconImgView = UIImageView()
    
    // Cụm Text trong Footer Card trắng
    private let textStack = UIStackView()
    private let titleRow = UIStackView()
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = false
        self.isRemainingSuffix = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = UIColor(hex: "#0B1528")
        
        // 1. Top Bar (#0B1528)
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        topBarView.backgroundColor = UIColor(hex: "#0B1528")
        addSubview(topBarView)
        
        // Pill đếm giờ bên trái trong Top Bar (3 cạnh thẳng, 1 cạnh cong phải)
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = UIColor(hex: "#2B3648")
        countdownContainerView.layer.cornerRadius = 14
        countdownContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        countdownContainerView.clipsToBounds = true
        topBarView.addSubview(countdownContainerView)
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = UIColor(hex: "#C5CCD6")
        countdownLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        countdownLbl.textAlignment = .center
        countdownContainerView.addSubview(countdownLbl)
        
        // Nút Close bên phải trong Top Bar
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        topBarView.addSubview(closeButton)
        
        // 2. Bottom Bar (#0B1528) sát mép đáy màn hình
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.backgroundColor = UIColor(hex: "#0B1528")
        addSubview(bottomBarView)
        
        // 3. Footer Card trắng (#FFFFFF) nằm ngay trên Bottom Bar
        footerCardView.translatesAutoresizingMaskIntoConstraints = false
        footerCardView.backgroundColor = .white
        addSubview(footerCardView)
        
        // 4. Center Container (#D9D9D9) ở giữa Top Bar và Footer Card
        centerContainerView.translatesAutoresizingMaskIntoConstraints = false
        centerContainerView.backgroundColor = UIColor(hex: "#D9D9D9")
        addSubview(centerContainerView)
        
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 24
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        centerContainerView.addSubview(largeIconImgView)
        
        // 5. Cấu hình các widget trong Footer Card trắng
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
        
        // Headline chữ đen (vì nền footer màu trắng)
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .black
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Advertiser chữ xám (#5F6368)
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#5F6368")
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
        footerCardView.addSubview(textStack)
        
        // Nút CTA xanh #1A73E8
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        footerCardView.addSubview(callToActionBtn)
        
        let iconSize = LayoutDimensions.largeIconSize
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            // Pill đếm giờ trong Top Bar chạm sát mép trái
            countdownContainerView.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor),
            countdownContainerView.heightAnchor.constraint(equalToConstant: 28),
            
            countdownLbl.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor, constant: 16),
            countdownLbl.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: -20),
            countdownLbl.centerYAnchor.constraint(equalTo: countdownContainerView.centerYAnchor),
            
            // Nút Close trong Top Bar
            closeButton.trailingAnchor.constraint(equalTo: topBarView.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            
            countdownContainerView.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            // Subviews trong Footer Card trắng
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Text bắt đầu từ lề trái footer
            textStack.leadingAnchor.constraint(equalTo: footerCardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: footerCardView.centerYAnchor),
            
            callToActionBtn.trailingAnchor.constraint(equalTo: footerCardView.trailingAnchor, constant: -16),
            callToActionBtn.centerYAnchor.constraint(equalTo: footerCardView.centerYAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: 120),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 40),
            
            // Icon lớn 180pt căn chính giữa Center Container
            largeIconImgView.centerXAnchor.constraint(equalTo: centerContainerView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: centerContainerView.centerYAnchor),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // Top Bar trải dài từ đỉnh màn hình xuống dưới Safe Area 64pt
            topBarView.topAnchor.constraint(equalTo: topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBarView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 64),
            
            // Nút Close và Pill đếm giờ nằm ở giữa khu vực 64pt dưới Safe Area (tương đương Inter)
            closeButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            
            // Center Container bắt đầu ngay dưới Top Bar (tự động đẩy xuống theo)
            centerContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            centerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            centerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            centerContainerView.bottomAnchor.constraint(equalTo: footerCardView.topAnchor),
            
            // Footer Card trắng
            footerCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerCardView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            footerCardView.heightAnchor.constraint(equalToConstant: 72),
            
            // Bottom Bar
            bottomBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 36)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        landscapeConstraints = [
            // Top Bar
            topBarView.topAnchor.constraint(equalTo: topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 54),
            
            closeButton.centerYAnchor.constraint(equalTo: topBarView.centerYAnchor),
            
            // Center Container
            centerContainerView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            centerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            centerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            centerContainerView.bottomAnchor.constraint(equalTo: footerCardView.topAnchor),
            
            // Footer Card trắng
            footerCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerCardView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            footerCardView.heightAnchor.constraint(equalToConstant: 64),
            
            // Bottom Bar
            bottomBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 24)
        ]
        
        updateOrientationConstraints()
    }
    
    public override func populate(nativeAd: GADNativeAd) {
        self.mediaView = nil
        self.imageView = nil
        super.populate(nativeAd: nativeAd)
        if let icon = nativeAd.icon {
            largeIconImgView.image = icon.image
            largeIconImgView.isHidden = false
        }
        self.iconView = largeIconImgView
    }
}
