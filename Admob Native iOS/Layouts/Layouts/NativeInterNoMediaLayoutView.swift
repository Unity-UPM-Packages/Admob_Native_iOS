//
//  NativeInterNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Interstitial No-Media toàn màn hình (Chỉ dùng Icon lớn 180pt căn giữa thay cho MediaView, không dùng icon bé).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_inter_no_media.xml & res/layout-land/native_inter_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeInterNoMediaLayoutView: BaseNativeAdLayoutView {
    
    // Top & Bottom Card
    private let topCardView = UIView()
    private let topDividerView = UIView()
    private let bottomCardView = UIView()
    private let bottomDividerView = UIView()
    
    // Icon lớn 180pt căn chính giữa trung tâm
    public let largeIconImgView = UIImageView()
    
    // Cụm Text (Ad Badge + Headline nằm ngang hàng, Advertiser ở dưới)
    private let textStack = UIStackView()
    private let titleRow = UIStackView()
    
    private var lastAppliedIsLandscape: Bool?
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .gntBgDark
        
        // 1. Icon lớn 180pt ở khu vực trung tâm
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 24
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        addSubview(largeIconImgView)
        
        // 2. Dividers (#505763)
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = .gntBorderDark
        addSubview(topDividerView)
        
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = .gntBorderDark
        addSubview(bottomDividerView)
        
        // 3. Top Card
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.backgroundColor = .gntBgDark
        topCardView.clipsToBounds = true
        addSubview(topCardView)
        
        // 4. Bottom Card
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = .gntBgDark
        bottomCardView.clipsToBounds = true
        addSubview(bottomCardView)
        
        // 5. Cụm Text
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
        advertiserLbl.textColor = .gntSecondaryText
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
        
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        bottomCardView.addSubview(callToActionBtn)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        // 6. Thanh ProgressBar màu vàng ở sát mép trên màn dọc
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = true
        addSubview(progressBar)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
        
        // Base Constraints
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            topDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            bottomDividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let iconSize = LayoutDimensions.largeIconSize
        
        // PORTRAIT CONSTRAINTS (Màn Dọc)
        // ProgressBar và Top Card nằm dưới Safe Area (Dynamic Island / Tai thỏ)
        portraitConstraints = [
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            topCardView.topAnchor.constraint(equalTo: progressBar.bottomAnchor),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 64),
            
            textStack.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            textStack.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -10),
            
            closeButton.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),
            
            topDividerView.topAnchor.constraint(equalTo: topCardView.bottomAnchor),
            
            largeIconImgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.topAnchor.constraint(greaterThanOrEqualTo: topDividerView.bottomAnchor, constant: 16),
            largeIconImgView.bottomAnchor.constraint(lessThanOrEqualTo: bottomDividerView.topAnchor, constant: -16),
            
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
        
        // LANDSCAPE CONSTRAINTS (Màn Ngang)
        landscapeConstraints = [
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 0),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            topDividerView.topAnchor.constraint(equalTo: topAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            largeIconImgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 16),
            largeIconImgView.bottomAnchor.constraint(lessThanOrEqualTo: bottomDividerView.topAnchor, constant: -16),
            
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.heightAnchor.constraint(equalToConstant: 64),
            
            // Text tràn sang bên trái (vì không dùng icon nhỏ)
            textStack.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            
            callToActionBtn.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -16),
            callToActionBtn.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: 120),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 40)
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
            bottomCardView.addSubview(textStack)
            bottomCardView.addSubview(callToActionBtn)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            topCardView.addSubview(textStack)
            bottomCardView.addSubview(callToActionBtn)
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
}
