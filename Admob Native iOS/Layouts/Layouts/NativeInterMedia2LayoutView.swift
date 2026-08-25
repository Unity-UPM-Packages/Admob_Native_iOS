//
//  NativeInterMedia2LayoutView.swift
//  Admob Native iOS
//
//  Layout Interstitial Split 50/50 Media (Edge-to-Edge).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_inter_media_2.xml & res/layout-land/native_inter_media_2.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeInterMedia2LayoutView: BaseNativeAdLayoutView {
    
    // Portrait: Top Media Container (#D9D9D9) & Bottom Card (#FFFFFF)
    // Landscape: Left Media Container (50% #D9D9D9) & Right Info Container (50% #FFFFFF)
    private let mediaContainerView = UIView()
    private let infoContainerView = UIView()
    
    // Cụm Header Text
    private let titleRow = UIStackView()
    private let textStack = UIStackView()
    
    // Hàng 2 nút bấm cho màn ngang (Close viền xám + CTA xanh lá)
    private let landscapeButtonRow = UIStackView()
    private let landscapeCloseBtn = UIButton(type: .system)
    
    // Circular Countdown ở góc trên bên phải màn ngang
    private let circularCountdownView = UIView()
    
    public init() {
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .white
        
        // 1. Media Container (#D9D9D9)
        mediaContainerView.translatesAutoresizingMaskIntoConstraints = false
        mediaContainerView.backgroundColor = UIColor(hex: "#D9D9D9")
        mediaContainerView.clipsToBounds = true
        addSubview(mediaContainerView)
        
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMediaView.contentMode = .scaleAspectFit
        adMediaView.backgroundColor = UIColor(hex: "#D9D9D9")
        mediaContainerView.addSubview(adMediaView)
        
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
        progressBar.progressTintColor = .gntAdBadgeYellow
        progressBar.trackTintColor = .clear
        addSubview(progressBar)
        
        // 7. Circular Countdown (màn ngang)
        circularCountdownView.translatesAutoresizingMaskIntoConstraints = false
        circularCountdownView.backgroundColor = .white
        circularCountdownView.layer.borderColor = UIColor(hex: "#7F7F7F").cgColor
        circularCountdownView.layer.borderWidth = 1.5
        circularCountdownView.layer.cornerRadius = 14
        circularCountdownView.clipsToBounds = true
        
        countdownLbl.translatesAutoresizingMaskIntoConstraints = false
        countdownLbl.textColor = UIColor(hex: "#7F7F7F")
        countdownLbl.font = UIFont.boldSystemFont(ofSize: 12)
        countdownLbl.textAlignment = .center
        circularCountdownView.addSubview(countdownLbl)
        infoContainerView.addSubview(circularCountdownView)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),
            
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // MediaView bên trong Media Container
            adMediaView.topAnchor.constraint(equalTo: mediaContainerView.topAnchor),
            adMediaView.bottomAnchor.constraint(equalTo: mediaContainerView.bottomAnchor),
            adMediaView.leadingAnchor.constraint(equalTo: mediaContainerView.leadingAnchor),
            adMediaView.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
            
            // Circular countdown view
            circularCountdownView.widthAnchor.constraint(equalToConstant: 28),
            circularCountdownView.heightAnchor.constraint(equalToConstant: 28),
            circularCountdownView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 16),
            circularCountdownView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            
            countdownLbl.centerXAnchor.constraint(equalTo: circularCountdownView.centerXAnchor),
            countdownLbl.centerYAnchor.constraint(equalTo: circularCountdownView.centerYAnchor)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // Media Container ở trên
            mediaContainerView.topAnchor.constraint(equalTo: topAnchor),
            mediaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaContainerView.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor),
            
            // Nút Close X ở góc trên bên phải trong safe area (nâng cao hơn)
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
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
            // Nửa trái 50%: Media Container (#D9D9D9)
            mediaContainerView.topAnchor.constraint(equalTo: topAnchor),
            mediaContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mediaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // Nửa phải 50%: Info Container (#FFFFFF)
            infoContainerView.topAnchor.constraint(equalTo: topAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.leadingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
            
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
        
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)
        
        if isLandscape {
            closeButton.isHidden = true
            circularCountdownView.isHidden = false
            landscapeButtonRow.addArrangedSubview(landscapeCloseBtn)
            landscapeButtonRow.addArrangedSubview(callToActionBtn)
            infoContainerView.addSubview(landscapeButtonRow)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            closeButton.isHidden = false
            circularCountdownView.isHidden = true
            infoContainerView.addSubview(callToActionBtn)
            landscapeButtonRow.removeFromSuperview()
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
    }
    
    @objc private func handleLandscapeCloseTapped() {
        onCloseClicked?()
    }
}
