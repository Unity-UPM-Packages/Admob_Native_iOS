//
//  NativeMrecLayoutView.swift
//  Admob Native iOS
//
//  Layout Native MREC (Medium Rectangle 300x250 format).
//

import UIKit
import GoogleMobileAds

public final class NativeMrecLayoutView: BaseNativeAdLayoutView {
    
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
        backgroundColor = .clear
        cardContainerView.backgroundColor = .gntBgNativeSolid
        cardContainerView.layer.cornerRadius = 8
        
        addSubview(cardContainerView)
        
        cardContainerView.addSubview(isNoMediaVariant ? mainImgView : adMediaView)
        
        let footerStack = UIStackView()
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 8
        cardContainerView.addSubview(footerStack)
        
        footerStack.addArrangedSubview(iconImgView)
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2
        
        let titleRow = UIStackView()
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 4
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(advertiserLbl)
        
        footerStack.addArrangedSubview(textStack)
        footerStack.addArrangedSubview(callToActionBtn)
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Kích thước chuẩn MREC 300x250 (hoặc co giãn theo container)
            cardContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            cardContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            
            (isNoMediaVariant ? mainImgView : adMediaView).topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 6),
            (isNoMediaVariant ? mainImgView : adMediaView).leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 6),
            (isNoMediaVariant ? mainImgView : adMediaView).trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -6),
            (isNoMediaVariant ? mainImgView : adMediaView).bottomAnchor.constraint(equalTo: footerStack.topAnchor, constant: -6),
            
            footerStack.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 8),
            footerStack.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8),
            footerStack.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -8),
            footerStack.heightAnchor.constraint(equalToConstant: 48),
            
            iconImgView.widthAnchor.constraint(equalToConstant: 32),
            iconImgView.heightAnchor.constraint(equalToConstant: 32),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 20),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 14),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: 90),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}
