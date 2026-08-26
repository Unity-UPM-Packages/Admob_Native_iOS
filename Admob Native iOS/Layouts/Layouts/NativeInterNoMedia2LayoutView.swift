//
//  NativeInterNoMedia2LayoutView.swift
//  Admob Native iOS
//
//  Layout Interstitial Split 50/50 No-Media (Icon lớn 180pt căn giữa trên nền xám #D9D9D9).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_inter_no_media_2.xml & res/layout-land/native_inter_no_media_2.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeInterNoMedia2LayoutView: BaseNativeAdLayoutView {
    
    // Portrait: Top Icon Container (#D9D9D9) & Bottom Card (#FFFFFF)
    // Landscape: Left Icon Container (50% #D9D9D9) & Right Info Container (50% #FFFFFF)
    private let iconContainerView = UIView()
    private let infoContainerView = UIView()
    
    // Icon lớn 180pt căn chính giữa trung tâm
    public let largeIconImgView = UIImageView()
    
    // Cụm Header Text
    private let titleRow = UIStackView()
    private let textStack = UIStackView()
    
    // Hàng 2 nút bấm cho màn ngang (Close viền xám + CTA xanh lá)
    private let landscapeButtonRow = UIStackView()
    private let landscapeCloseBtn = UIButton(type: .system)
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .white
        
        // 1. Icon Container (#D9D9D9)
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.backgroundColor = UIColor(hex: "#D9D9D9")
        iconContainerView.clipsToBounds = true
        addSubview(iconContainerView)
        
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 24
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        iconContainerView.addSubview(largeIconImgView)
        
        // 2. Info Container (#FFFFFF)
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.backgroundColor = .white
        infoContainerView.clipsToBounds = true
        addSubview(infoContainerView)
        
        // 3. Cấu hình Cụm Text
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
        
        // Headline chữ đen
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .black
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 16)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Advertiser chữ xám
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
        textStack.spacing = 4
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(advertiserLbl)
        infoContainerView.addSubview(textStack)
        
        // 4. Nút CTA xanh lá cây (#34A853)
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#34A853")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        infoContainerView.addSubview(callToActionBtn)
        
        // 5. Nút Close dạng Button chữ viền xám cho màn ngang (CLOSE)
        landscapeCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        landscapeCloseBtn.backgroundColor = .white
        landscapeCloseBtn.layer.borderColor = UIColor(hex: "#7F7F7F").cgColor
        landscapeCloseBtn.layer.borderWidth = 1
        landscapeCloseBtn.layer.cornerRadius = 6
        landscapeCloseBtn.setTitle("CLOSE", for: .normal)
        landscapeCloseBtn.setTitleColor(.black, for: .normal)
        landscapeCloseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        landscapeCloseBtn.addTarget(self, action: #selector(handleLandscapeCloseTapped), for: .touchUpInside)
        
        landscapeButtonRow.translatesAutoresizingMaskIntoConstraints = false
        landscapeButtonRow.axis = .horizontal
        landscapeButtonRow.distribution = .fillEqually
        landscapeButtonRow.spacing = 12
        landscapeButtonRow.addArrangedSubview(landscapeCloseBtn)
        landscapeButtonRow.addArrangedSubview(callToActionBtn)
        
        // 6. Nút Close dạng tròn X (màn dọc) và Progress Bar Line Fill sát mép trên
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = true
        addSubview(progressBar)
        
        // 7. Circular Countdown (màn ngang - dùng countdownContainerView & circularProgressView kế thừa)
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = .clear
        countdownContainerView.isHidden = true
        countdownLbl.textColor = UIColor(hex: "#7F7F7F")
        infoContainerView.addSubview(countdownContainerView)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
        
        let iconSize = LayoutDimensions.largeIconSize
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Icon lớn 180pt căn giữa Icon Container
            largeIconImgView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),
            
            // Circular countdown view (24x24dp giống Android)
            countdownContainerView.widthAnchor.constraint(equalToConstant: 24),
            countdownContainerView.heightAnchor.constraint(equalToConstant: 24),
            countdownContainerView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 15),
            countdownContainerView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -15)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // ProgressBar nằm dưới Safe Area (Dynamic Island / Tai thỏ)
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            // Icon Container ở trên
            iconContainerView.topAnchor.constraint(equalTo: topAnchor),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconContainerView.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor),
            
            // Nút Close X ở vị trí tương đương phiên bản không 2 (cách progressBar 18pt)
            closeButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 18),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Info Container (Bottom Card trắng)
            infoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoContainerView.heightAnchor.constraint(equalToConstant: 130),
            
            // Cụm Text trong bottom card
            textStack.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            textStack.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 14),
            
            // Nút CTA xanh tràn viền ngang ở đáy
            callToActionBtn.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            callToActionBtn.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 12),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Phân Chia 50/50 2 Nửa)
        // -------------------------------------------------------------
        landscapeConstraints = [
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            
            // Nửa trái 50%: Icon Container (#D9D9D9)
            iconContainerView.topAnchor.constraint(equalTo: topAnchor),
            iconContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // Nửa phải 50%: Info Container (#FFFFFF)
            infoContainerView.topAnchor.constraint(equalTo: topAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor),
            
            // Cụm Text ở giữa nửa phải
            textStack.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 32),
            textStack.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -32),
            textStack.bottomAnchor.constraint(equalTo: landscapeButtonRow.topAnchor, constant: -16),
            
            // Hàng 2 nút bấm phân chia 50/50 (CLOSE + CTA)
            landscapeButtonRow.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 32),
            landscapeButtonRow.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -32),
            landscapeButtonRow.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor, constant: 28),
            landscapeButtonRow.heightAnchor.constraint(equalToConstant: 44)
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
            self.isRemainingSuffix = false
            progressBar.isHidden = true
            closeButton.isHidden = true
            countdownContainerView.isHidden = false
            circularProgressView.isHidden = false
            circularProgressView.progressColor = UIColor(hex: "#7F7F7F")
            countdownLbl.textColor = UIColor(hex: "#7F7F7F")
            
            landscapeButtonRow.addArrangedSubview(landscapeCloseBtn)
            landscapeButtonRow.addArrangedSubview(callToActionBtn)
            infoContainerView.addSubview(landscapeButtonRow)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            self.isLineFill = true
            self.isRemainingSuffix = false
            countdownContainerView.isHidden = true
            progressBar.isHidden = false
            
            infoContainerView.addSubview(callToActionBtn)
            landscapeButtonRow.removeFromSuperview()
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
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
    
    @objc private func handleLandscapeCloseTapped() {
        onCloseClicked?()
    }
}
