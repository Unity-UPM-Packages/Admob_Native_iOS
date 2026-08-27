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
    private let landscapeButtonRow = UIView()
    public let landscapeCloseBtn = UIButton(type: .system)
    
    public override var landscapeCloseButton: UIButton? {
        return landscapeCloseBtn
    }
    
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
        
        // 3. Icon ứng dụng (bo góc 6pt)
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.layer.cornerRadius = 6
        iconImgView.clipsToBounds = true
        iconImgView.contentMode = .scaleAspectFit
        infoContainerView.addSubview(iconImgView)
        
        // 4. Cấu hình Cụm Text
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
        
        // 5. Nút CTA xanh lá cây (#34A853)
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#34A853")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        infoContainerView.addSubview(callToActionBtn)
        
        // 6. Nút Close dạng Button chữ viền xám cho màn ngang (CLOSE)
        landscapeCloseBtn.translatesAutoresizingMaskIntoConstraints = false
        landscapeCloseBtn.backgroundColor = .white
        landscapeCloseBtn.layer.borderColor = UIColor(hex: "#7F7F7F").cgColor
        landscapeCloseBtn.layer.borderWidth = 1
        landscapeCloseBtn.layer.cornerRadius = 6
        landscapeCloseBtn.setTitle("CLOSE", for: .normal)
        landscapeCloseBtn.setTitleColor(.black, for: .normal)
        landscapeCloseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        landscapeCloseBtn.isHidden = true
        landscapeCloseBtn.alpha = 0.5
        landscapeCloseBtn.isUserInteractionEnabled = false
        landscapeCloseBtn.addTarget(self, action: #selector(handleLandscapeCloseTapped), for: .touchUpInside)
        
        landscapeButtonRow.translatesAutoresizingMaskIntoConstraints = false
        
        // 7. Nút Close dạng tròn X (màn dọc) và Progress Bar Line Fill sát mép trên
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.isHidden = true
        addSubview(progressBar)
        
        // 8. Countdown Container (màn ngang)
        countdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        countdownContainerView.backgroundColor = .clear
        countdownContainerView.isHidden = true
        countdownLbl.textColor = UIColor(hex: "#7F7F7F")
        infoContainerView.addSubview(countdownContainerView)
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
        
        // Base Constraints cố định
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
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
            
            // Circular countdown view (24x24dp)
            countdownContainerView.widthAnchor.constraint(equalToConstant: 24),
            countdownContainerView.heightAnchor.constraint(equalToConstant: 24),
            countdownContainerView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 15),
            countdownContainerView.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -15)
        ])
        
        // -------------------------------------------------------------
        // PORTRAIT CONSTRAINTS (Màn Dọc - Toàn Màn Hình Edge-to-Edge)
        // -------------------------------------------------------------
        portraitConstraints = [
            // ProgressBar nằm dưới Safe Area
            progressBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            // Media Container ở trên
            mediaContainerView.topAnchor.constraint(equalTo: topAnchor),
            mediaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mediaContainerView.bottomAnchor.constraint(equalTo: infoContainerView.topAnchor),
            
            // Nút Close X ở vị trí tương đương
            closeButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 18),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Info Container ở dưới (Bottom Card trắng - GIỮ NGUYÊN 130pt)
            infoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoContainerView.heightAnchor.constraint(equalToConstant: 130),
            
            // Icon ứng dụng ở thẻ dưới bên trái (36x36pt)
            iconImgView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            iconImgView.topAnchor.constraint(equalTo: infoContainerView.topAnchor, constant: 14),
            iconImgView.widthAnchor.constraint(equalToConstant: 36),
            iconImgView.heightAnchor.constraint(equalToConstant: 36),
            
            // Cụm Text trong bottom card (nằm bên phải Icon, cách 10pt)
            textStack.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 10),
            textStack.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: iconImgView.centerYAnchor),
            
            // Nút CTA xanh tràn viền ngang ở đáy
            callToActionBtn.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 16),
            callToActionBtn.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -16),
            callToActionBtn.topAnchor.constraint(equalTo: iconImgView.bottomAnchor, constant: 12),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        // -------------------------------------------------------------
        // LANDSCAPE CONSTRAINTS (Màn Ngang - Phân Chia 50% / 50%)
        // -------------------------------------------------------------
        landscapeConstraints = [
            // Media Container bên trái chiếm đúng 50%
            mediaContainerView.topAnchor.constraint(equalTo: topAnchor),
            mediaContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mediaContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mediaContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // Info Container bên phải chiếm đúng 50%
            infoContainerView.topAnchor.constraint(equalTo: topAnchor),
            infoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            infoContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            // Cụm Text ở giữa nửa phải (căn chỉnh cân đối với hàng nút)
            textStack.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 32),
            textStack.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -32),
            textStack.bottomAnchor.constraint(equalTo: landscapeButtonRow.topAnchor, constant: -16),
            
            // Hàng 2 nút bấm phân chia 50/50 (CLOSE + CTA) căn giữa nửa phải giống Inter No Media 2
            landscapeButtonRow.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor, constant: 32),
            landscapeButtonRow.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor, constant: -32),
            landscapeButtonRow.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor, constant: 28),
            landscapeButtonRow.heightAnchor.constraint(equalToConstant: 44),
            
            // Nút Close chiếm 50% bên trái (cách tâm 6pt)
            landscapeCloseBtn.topAnchor.constraint(equalTo: landscapeButtonRow.topAnchor),
            landscapeCloseBtn.bottomAnchor.constraint(equalTo: landscapeButtonRow.bottomAnchor),
            landscapeCloseBtn.leadingAnchor.constraint(equalTo: landscapeButtonRow.leadingAnchor),
            landscapeCloseBtn.trailingAnchor.constraint(equalTo: landscapeButtonRow.centerXAnchor, constant: -6),
            
            // Nút CTA chiếm 50% bên phải (cách tâm 6pt) - CỐ ĐỊNH KÍCH THƯỚC không bị dãn khi Close ẩn/hiện
            callToActionBtn.topAnchor.constraint(equalTo: landscapeButtonRow.topAnchor),
            callToActionBtn.bottomAnchor.constraint(equalTo: landscapeButtonRow.bottomAnchor),
            callToActionBtn.leadingAnchor.constraint(equalTo: landscapeButtonRow.centerXAnchor, constant: 6),
            callToActionBtn.trailingAnchor.constraint(equalTo: landscapeButtonRow.trailingAnchor)
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
            self.isCircularProgress = true
            self.isRemainingSuffix = false
            progressBar.isHidden = true
            closeButton.isHidden = true
            iconImgView.isHidden = true
            countdownContainerView.isHidden = false
            countdownLbl.isHidden = false
            circularProgressView.isHidden = false
            circularProgressView.progressColor = UIColor(hex: "#7F7F7F")
            countdownLbl.textColor = UIColor(hex: "#7F7F7F")
            
            landscapeButtonRow.addSubview(landscapeCloseBtn)
            landscapeButtonRow.addSubview(callToActionBtn)
            infoContainerView.addSubview(landscapeButtonRow)
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            self.isLineFill = true
            self.isCircularProgress = false
            self.isRemainingSuffix = false
            countdownContainerView.isHidden = true
            circularProgressView.isHidden = true
            progressBar.isHidden = false
            iconImgView.isHidden = false
            
            landscapeCloseBtn.removeFromSuperview()
            landscapeButtonRow.removeFromSuperview()
            infoContainerView.addSubview(callToActionBtn)
            NSLayoutConstraint.activate(portraitConstraints)
        }
        
        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)
    }
    
    @objc private func handleLandscapeCloseTapped() {
        onCloseClicked?()
    }
}
