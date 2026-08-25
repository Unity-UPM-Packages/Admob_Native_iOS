//
//  NativeInterLayoutView.swift
//  Admob Native iOS
//
//  Layout Interstitial toàn màn hình (Edge-to-Edge) - Khớp 1:1 chuẩn xác với Android native_inter_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeInterLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    private let isSplitVariant: Bool
    
    // Top & Bottom Card
    private let topCardView = UIView()
    private let topDividerView = UIView()
    private let bottomCardView = UIView()
    private let bottomDividerView = UIView()
    
    // Cụm Header Text (Ad Badge + Headline nằm ngang hàng, Advertiser ở dưới)
    private let textStack = UIStackView()
    private let titleRow = UIStackView()
    
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
        
        // 1. Media View / Image View (Chiếm trọn không gian giữa)
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        mediaOrImage.translatesAutoresizingMaskIntoConstraints = false
        mediaOrImage.contentMode = .scaleAspectFit
        mediaOrImage.backgroundColor = .clear
        addSubview(mediaOrImage)
        
        // 2. Dividers (#505763)
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.backgroundColor = .gntBorderDark
        addSubview(topDividerView)
        
        bottomDividerView.translatesAutoresizingMaskIntoConstraints = false
        bottomDividerView.backgroundColor = .gntBorderDark
        addSubview(bottomDividerView)
        
        // 3. Top Card (Tràn kín đỉnh màn hình bao gồm cả Dynamic Island / Tai thỏ)
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.backgroundColor = .gntBgDark
        addSubview(topCardView)
        
        // 4. Bottom Card (Tràn kín đáy màn hình bao gồm cả Home Indicator)
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = .gntBgDark
        addSubview(bottomCardView)
        
        // 5. Cụm Text: titleRow (Ad Badge ngang hàng Headline) + advertiserLbl ở dưới
        titleRow.translatesAutoresizingMaskIntoConstraints = false
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 6
        
        // Style Ad Badge vàng chữ nâu
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        // Style Headline trắng bold
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 15)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // Style Advertiser
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
        
        // 6. Subviews khác
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.layer.cornerRadius = 6
        iconImgView.clipsToBounds = true
        
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        
        // Nút Close và Progress Bar nổi lên trên cùng (Z-Index cao nhất)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .gntAdBadgeYellow
        progressBar.trackTintColor = .clear
        addSubview(progressBar)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: topAnchor),
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
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            iconImgView.widthAnchor.constraint(equalToConstant: 44),
            iconImgView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // Top Card tràn từ đỉnh màn hình xuống
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCardView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Cụm Text ở Top Card căn chỉnh né Notch/Dynamic Island
            textStack.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: 16),
            textStack.bottomAnchor.constraint(equalTo: topCardView.bottomAnchor, constant: -12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -10),
            
            // Nút Close căn giữa theo chiều dọc của cụm text
            closeButton.trailingAnchor.constraint(equalTo: topCardView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: textStack.centerYAnchor),
            
            // Top Divider ngay dưới top_card
            topDividerView.topAnchor.constraint(equalTo: topCardView.bottomAnchor),
            
            // Media View ở giữa 2 divider
            mediaOrImage.topAnchor.constraint(equalTo: topDividerView.bottomAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor),
            
            // Bottom Divider ngay trên bottom_card
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            // Bottom Card tràn xuống tận đáy màn hình
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -64),
            
            // CTA Button TRÀN TOÀN BỘ CHIỀU NGANG trong bottom_card
            callToActionBtn.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -16),
            callToActionBtn.topAnchor.constraint(equalTo: bottomCardView.topAnchor, constant: 10),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        landscapeConstraints = [
            // Top Card ẩn
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: 0),
            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            topDividerView.topAnchor.constraint(equalTo: topAnchor),
            topDividerView.heightAnchor.constraint(equalToConstant: 0),
            
            // Nút Close ở góc trên bên phải màn hình (nổi trên MediaView)
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Media View chiếm toàn bộ không gian phía trên
            mediaOrImage.topAnchor.constraint(equalTo: topAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor),
            
            // Bottom Divider
            bottomDividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            
            // Bottom Card tràn sát mép đáy
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.heightAnchor.constraint(equalToConstant: 64),
            
            // Icon ở bên trái bottom_card
            iconImgView.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 20),
            iconImgView.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            
            // Cụm Text ở giữa (ngang giữa so với Icon và CTA)
            textStack.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            
            // CTA Button ở bên phải bottom_card
            callToActionBtn.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -20),
            callToActionBtn.centerYAnchor.constraint(equalTo: bottomCardView.centerYAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: 120),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        updateOrientationConstraints()
    }
    
    public override func updateOrientationConstraints() {
        super.updateOrientationConstraints()
        let isLandscape = bounds.width > bounds.height
        
        // Ẩn/Hiện Icon tùy theo Portrait / Landscape
        iconImgView.isHidden = !isLandscape
        
        // Chuyển cụm textStack và các view vào đúng View cha
        if isLandscape {
            if iconImgView.superview != bottomCardView { bottomCardView.addSubview(iconImgView) }
            if callToActionBtn.superview != bottomCardView { bottomCardView.addSubview(callToActionBtn) }
            if textStack.superview != bottomCardView { bottomCardView.addSubview(textStack) }
        } else {
            if textStack.superview != topCardView { topCardView.addSubview(textStack) }
            if callToActionBtn.superview != bottomCardView { bottomCardView.addSubview(callToActionBtn) }
        }
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
    }
}
