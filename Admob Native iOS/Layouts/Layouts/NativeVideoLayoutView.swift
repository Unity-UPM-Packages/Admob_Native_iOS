//
//  NativeVideoLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Video toàn màn hình hỗ trợ Portrait & Landscape.
//

import UIKit
import GoogleMobileAds

public final class NativeVideoLayoutView: BaseNativeAdLayoutView {
    
    private let footerStack = UIStackView()
    
    public init(layoutName: String = "native_video") {
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .black
        
        addSubview(adMediaView)
        addSubview(cardContainerView)
        addSubview(closeButton)
        addSubview(countdownContainerView)
        countdownContainerView.addSubview(countdownLbl)
        countdownContainerView.addSubview(progressBar)
        
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 10
        cardContainerView.addSubview(footerStack)
        
        footerStack.addArrangedSubview(iconImgView)
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 3
        
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 6
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(advertiserLbl)
        
        footerStack.addArrangedSubview(textStack)
        footerStack.addArrangedSubview(callToActionBtn)
        
        NSLayoutConstraint.activate([
            footerStack.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            footerStack.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            footerStack.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            
            iconImgView.widthAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            iconImgView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: LayoutDimensions.ctaWidth),
            callToActionBtn.heightAnchor.constraint(equalToConstant: LayoutDimensions.ctaHeight),
            
            closeButton.widthAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            closeButton.heightAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            
            countdownContainerView.heightAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            countdownContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            countdownLbl.centerYAnchor.constraint(equalTo: countdownContainerView.centerYAnchor),
            countdownLbl.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor, constant: 8),
            countdownLbl.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: -8),
            
            progressBar.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor, constant: 4),
            progressBar.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: -4),
            progressBar.bottomAnchor.constraint(equalTo: countdownContainerView.bottomAnchor, constant: -2),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        // PORTRAIT
        portraitConstraints = [
            adMediaView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            adMediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adMediaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adMediaView.bottomAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: -16),
            
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cardContainerView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerHeight + 16),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            countdownContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            countdownContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ]
        
        // LANDSCAPE (Video tràn toàn bộ màn hình, Footer card gọn phía dưới)
        landscapeConstraints = [
            adMediaView.topAnchor.constraint(equalTo: topAnchor),
            adMediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adMediaView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adMediaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cardContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cardContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -12),
            cardContainerView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerHeight),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            countdownContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            countdownContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ]
        
        updateOrientationConstraints()
    }
}

