//
//  NativeHalfScreenLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Half-Screen hỗ trợ Portrait & Landscape.
//

import UIKit
import GoogleMobileAds

public final class NativeHalfScreenLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    
    public init(layoutName: String) {
        self.isNoMediaVariant = layoutName.contains("no_media")
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        self.isNoMediaVariant = false
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        cardContainerView.backgroundColor = .gntBgNativeSolid
        cardContainerView.layer.cornerRadius = 16
        
        addSubview(cardContainerView)
        addSubview(closeButton)
        
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        cardContainerView.addSubview(mediaOrImage)
        
        let footerStack = UIStackView()
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
            mediaOrImage.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 12),
            mediaOrImage.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            mediaOrImage.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            mediaOrImage.bottomAnchor.constraint(equalTo: footerStack.topAnchor, constant: -8),
            
            footerStack.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 12),
            footerStack.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -12),
            footerStack.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -12),
            footerStack.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerHeight),
            
            iconImgView.widthAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            iconImgView.heightAnchor.constraint(equalToConstant: LayoutDimensions.footerIconSize),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: LayoutDimensions.ctaWidth),
            callToActionBtn.heightAnchor.constraint(equalToConstant: LayoutDimensions.ctaHeight),
            
            closeButton.widthAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize),
            closeButton.heightAnchor.constraint(equalToConstant: LayoutDimensions.closeBtnSize)
        ])
        
        // PORTRAIT
        portraitConstraints = [
            cardContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55),
            
            closeButton.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8)
        ]
        
        // LANDSCAPE (Card co gọn ở trung tâm 65% width, 85% height)
        landscapeConstraints = [
            cardContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardContainerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            cardContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.85),
            
            closeButton.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8)
        ]
        
        updateOrientationConstraints()
    }
}

