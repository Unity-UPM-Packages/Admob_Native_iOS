//
//  NativeRewardLayoutView.swift
//  Admob Native iOS
//
//  Layout Reward Native Ads Split Dark V1/V2 hỗ trợ Portrait & Landscape.
//

import UIKit
import GoogleMobileAds

public final class NativeRewardLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    private let isV2: Bool
    private let footerContainerView = UIView()
    private let footerStack = UIStackView()
    
    public init(layoutName: String) {
        self.isNoMediaVariant = layoutName.contains("no_media")
        self.isV2 = layoutName.contains("_2")
        super.init(frame: .zero)
        self.isLineFill = true
    }
    
    public required init?(coder: NSCoder) {
        self.isNoMediaVariant = false
        self.isV2 = false
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .gntBgDark
        cardContainerView.backgroundColor = .gntRewardBgDark
        footerContainerView.backgroundColor = .gntRewardBgDark
        
        if isV2 {
            callToActionBtn.backgroundColor = .gntRewardCtaV2
            callToActionBtn.layer.borderColor = UIColor.clear.cgColor
        }
        
        addSubview(cardContainerView)
        addSubview(closeButton)
        addSubview(countdownContainerView)
        countdownContainerView.addSubview(countdownLbl)
        countdownContainerView.addSubview(progressBar)
        
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        cardContainerView.addSubview(mediaOrImage)
        cardContainerView.addSubview(dividerView)
        cardContainerView.addSubview(footerContainerView)
        
        footerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 12
        footerContainerView.addSubview(footerStack)
        
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
            iconImgView.widthAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            iconImgView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: LayoutDimensions.ctaWidth),
            callToActionBtn.heightAnchor.constraint(equalToConstant: LayoutDimensions.ctaHeight),
            
            footerStack.leadingAnchor.constraint(equalTo: footerContainerView.leadingAnchor, constant: 16),
            footerStack.trailingAnchor.constraint(equalTo: footerContainerView.trailingAnchor, constant: -16),
            footerStack.centerYAnchor.constraint(equalTo: footerContainerView.centerYAnchor),
            
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
            cardContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            cardContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mediaOrImage.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: dividerView.topAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: footerContainerView.topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            footerContainerView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            footerContainerView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerHeight),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            countdownContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            countdownContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ]
        
        // LANDSCAPE
        landscapeConstraints = [
            cardContainerView.topAnchor.constraint(equalTo: topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mediaOrImage.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            mediaOrImage.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            mediaOrImage.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            mediaOrImage.bottomAnchor.constraint(equalTo: dividerView.topAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: footerContainerView.topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            footerContainerView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            footerContainerView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            footerContainerView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            footerContainerView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerHeight),
            
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            countdownContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            countdownContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ]
        
        updateOrientationConstraints()
    }
}

