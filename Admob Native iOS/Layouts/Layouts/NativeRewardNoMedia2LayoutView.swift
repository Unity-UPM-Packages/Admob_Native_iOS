//
//  NativeRewardNoMedia2LayoutView.swift
//  Admob Native iOS
//
//  Layout Reward Native Ads No-Media 2 toàn màn hình (CTA màu #3A3539, viền #7F7F7F; màn dọc dùng nút Close X).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_reward_no_media_2.xml & res/layout-land/native_reward_no_media_2.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeRewardNoMedia2LayoutView: BaseNativeAdLayoutView {
    
    // Portrait: Top Card, Top Divider, Icon Container, Bottom Divider, Bottom Card
    // Landscape: Left Container (50% #0B1528) & Right Container (50% #2F2A2E)
    private let topCardView = UIView()
    private let topDividerView = UIView()
    private let iconContainerView = UIView()
    private let bottomDividerView = UIView()
    private let bottomCardView = UIView()
    
    // Icon lớn 180pt căn giữa
    public let largeIconImgView = UIImageView()
    
    // Cụm Text
    private let titleRow = UIStackView()
    private let textStack = UIStackView()
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = UIColor(hex: "#0B1528")
        
        // 1. Containers
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.backgroundColor = UIColor(hex: "#0B1528")
        topCardView.clipsToBounds = true
        addSubview(topCardView)
        
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = UIColor(hex: "#505763")
        addSubview(topDividerView)
        
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor(hex: "#0B1528")
        iconContainerView.clipsToBounds = true
        addSubview(iconContainerView)
        
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 24
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        iconContainerView.addSubview(largeIconImgView)
        
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = UIColor(hex: "#505763")
        addSubview(bottomDividerView)
        
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = UIColor(hex: "#0B1528")
        bottomCardView.clipsToBounds = true
        addSubview(bottomCardView)
        
        // 2. Cụm Text ([Ad] vàng, Headline trắng, Advertiser xám #B6BCC3)
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
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B6BCC3")
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
        topCardView.addSubview(textStack)
        
        // 3. Nút Close / Skip (closeButton của BaseNativeAdLayoutView)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.isHidden = true // Mặc định ẩn hoàn toàn từ đầu
        addSubview(closeButton)
        
        // 4. Pill đếm giờ màn ngang (5s remaining...) bo góc phải (countdownContainerView của BaseNativeAdLayoutView)
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = UIColor(hex: "#2B3648")
        countdownContainerView.layer.cornerRadius = 14
        countdownContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        countdownContainerView.clipsToBounds = true
        countdownContainerView.isHidden = true // Mặc định ẩn hoàn toàn từ đầu
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = UIColor(hex: "#C5CCD6")
        countdownLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        countdownLbl.textAlignment = .center
        countdownLbl.isHidden = true
        countdownContainerView.addSubview(countdownLbl)
        addSubview(countdownContainerView)
        
        // 5. Nút CTA bản Reward 2: màu #3A3539, viền #7F7F7F
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#3A3539")
        callToActionBtn.layer.borderColor = UIColor(hex: "#7F7F7F").cgColor
        callToActionBtn.layer.borderWidth = 1
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callToActionBtn.clipsToBounds = true
        bottomCardView.addSubview(callToActionBtn)
        
        // 6. Thanh ProgressBar màu vàng ở sát mép trên màn dọc
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = true
        addSubview(progressBar)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(countdownContainerView)
        bringSubviewToFront(progressBar)
        
        let iconSize = LayoutDimensions.largeIconSize
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            // Icon lớn 180pt căn giữa Icon Container
            largeIconImgView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),
            
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            
            countdownContainerView.heightAnchor.constraint(equalToConstant: 28),
            countdownLbl.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor, constant: 16),
            countdownLbl.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: -20),
            countdownLbl.centerYAnchor.constraint(equalTo: countdownContainerView.centerYAnchor)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // ProgressBar nằm dưới Safe Area (Dynamic Island / Tai thỏ)
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            topCardView.topAnchor.constraint(equalTo: progressBar.bottomAnchor),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 64),
            
            textStack.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            textStack.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -10),
            
            // Nút Close dạng X neo độc lập ở giữa trục dọc Top Card
            closeButton.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            
            topDividerView.topAnchor.constraint(equalTo: topCardView.bottomAnchor),
            
            iconContainerView.topAnchor.constraint(equalTo: topDividerView.bottomAnchor),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconContainerView.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor),
            
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.heightAnchor.constraint(equalToConstant: 80),
            
            callToActionBtn.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -16),
            callToActionBtn.topAnchor.constraint(equalTo: bottomCardView.topAnchor, constant: 10),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Phân Chia 50/50 2 Nửa)
        // -------------------------------------------------------------
        landscapeConstraints = [
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 0),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: leadingAnchor),
            
            topDividerView.topAnchor.constraint(equalTo: topAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0),
            
            bottomDividerView.topAnchor.constraint(equalTo: topAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 0),
            
            // Nửa trái 50%: Icon Container (#0B1528)
            iconContainerView.topAnchor.constraint(equalTo: topAnchor),
            iconContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // Pill đếm giờ chạm sát mép trái
            countdownContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            countdownContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Nửa phải 50%: Bottom Card (đóng vai trò right_container màu #2F2A2E)
            bottomCardView.topAnchor.constraint(equalTo: topAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor),
            
            // Nút Close/Skip chạm sát mép phải
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            // Cụm Text ở giữa nửa phải
            textStack.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 32),
            textStack.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -32),
            textStack.bottomAnchor.constraint(equalTo: callToActionBtn.topAnchor, constant: -16),
            
            // Nút CTA ở giữa nửa phải (Rộng 160pt, cao 38pt chuẩn Android)
            callToActionBtn.centerXAnchor.constraint(equalTo: bottomCardView.centerXAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: 160),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 38),
            callToActionBtn.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor, constant: 28)
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
            self.isLineFill = false
            self.isRemainingSuffix = true
            
            // Chuyển nút Close thành dạng Skip Pill bo góc trái
            closeButton.setImage(createSkipIcon().withRenderingMode(.alwaysOriginal), for: .normal)
            closeButton.setTitle(" Skip", for: .normal)
            closeButton.setTitleColor(.white, for: .normal)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            closeButton.backgroundColor = UIColor(hex: "#2B3648")
            closeButton.layer.cornerRadius = 14
            closeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            closeButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
            
            bottomCardView.backgroundColor = UIColor(hex: "#2F2A2E")
            bottomCardView.addSubview(textStack)
            bottomCardView.addSubview(callToActionBtn)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            self.isLineFill = true
            self.isRemainingSuffix = false
            
            // Chuyển nút Close thành dạng tròn X 28pt ở góc Top Card
            closeButton.setImage(createCloseIcon(), for: .normal)
            closeButton.setTitle(nil, for: .normal)
            closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            closeButton.layer.cornerRadius = 14
            closeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            closeButton.contentEdgeInsets = .zero
            
            bottomCardView.backgroundColor = UIColor(hex: "#0B1528")
            topCardView.addSubview(textStack)
            bottomCardView.addSubview(callToActionBtn)
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(countdownContainerView)
        bringSubviewToFront(progressBar)
    }
    
    public override func populate(nativeAd: GADNativeAd) {
        self.imageView = nil
        super.populate(nativeAd: nativeAd)
        if let icon = nativeAd.icon {
            largeIconImgView.image = icon.image
            largeIconImgView.isHidden = false
        }
        self.iconView = largeIconImgView
    }
    
    private func createSkipIcon() -> UIImage {
        let size = CGSize(width: 14, height: 12)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let path = UIBezierPath()
            // Tam giác 1
            path.move(to: CGPoint(x: 1, y: 1))
            path.addLine(to: CGPoint(x: 6, y: 6))
            path.addLine(to: CGPoint(x: 1, y: 11))
            path.close()
            // Tam giác 2
            path.move(to: CGPoint(x: 7, y: 1))
            path.addLine(to: CGPoint(x: 12, y: 6))
            path.addLine(to: CGPoint(x: 7, y: 11))
            path.close()
            
            UIColor.white.setFill()
            path.fill()
        }
    }
}
