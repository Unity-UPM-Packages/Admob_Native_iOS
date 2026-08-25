//
//  NativeAppOpenLayoutView.swift
//  Admob Native iOS
//
//  Layout AppOpen toàn màn hình hỗ trợ Portrait và Landscape kèm kỹ thuật High-CTR.
//

import UIKit
import GoogleMobileAds

public final class NativeAppOpenLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    private let footerContainerView = UIView()
    private let footerStack = UIStackView()
    private let visualTitleLbl = UILabel()
    
    public init(layoutName: String) {
        self.isNoMediaVariant = layoutName.contains("no_media")
        super.init(frame: .zero)
        self.isRemainingSuffix = true
    }
    
    public required init?(coder: NSCoder) {
        self.isNoMediaVariant = false
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .gntBgDark
        
        // 1. HIGH-CTR HEADLINE (chiếm 100% diện tích hit-test)
        addSubview(headlineLbl)
        headlineLbl.textColor = .clear
        
        // 2. Visual Subviews
        addSubview(cardContainerView)
        addSubview(closeButton)
        addSubview(countdownContainerView)
        countdownContainerView.addSubview(countdownLbl)
        
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        cardContainerView.addSubview(mediaOrImage)
        cardContainerView.addSubview(dividerView)
        cardContainerView.addSubview(footerContainerView)
        
        footerContainerView.translatesAutoresizingMaskIntoConstraints = false
        footerContainerView.backgroundColor = .gntBgDark
        
        footerStack.translatesAutoresizingMaskIntoConstraints = false
        footerStack.axis = .horizontal
        footerStack.alignment = .center
        footerStack.spacing = 12
        footerContainerView.addSubview(footerStack)
        
        footerStack.addArrangedSubview(iconImgView)
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 3
        
        let visibleTitleRow = UIStackView()
        visibleTitleRow.axis = .horizontal
        visibleTitleRow.alignment = .center
        visibleTitleRow.spacing = 6
        visibleTitleRow.addArrangedSubview(adBadgeLbl)
        
        visualTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        visualTitleLbl.textColor = .white
        visualTitleLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.headlineTextSize)
        visualTitleLbl.numberOfLines = 1
        visualTitleLbl.lineBreakMode = .byTruncatingTail
        visibleTitleRow.addArrangedSubview(visualTitleLbl)
        
        textStack.addArrangedSubview(visibleTitleRow)
        textStack.addArrangedSubview(advertiserLbl)
        
        footerStack.addArrangedSubview(textStack)
        footerStack.addArrangedSubview(callToActionBtn)
        
        // Base Constraints
        NSLayoutConstraint.activate([
            headlineLbl.topAnchor.constraint(equalTo: topAnchor),
            headlineLbl.bottomAnchor.constraint(equalTo: bottomAnchor),
            headlineLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            headlineLbl.trailingAnchor.constraint(equalTo: trailingAnchor),
            
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
            
            countdownLbl.centerYAnchor.constraint(equalTo: countdownContainerView.centerYAnchor),
            countdownLbl.leadingAnchor.constraint(equalTo: countdownContainerView.leadingAnchor, constant: 10),
            countdownLbl.trailingAnchor.constraint(equalTo: countdownContainerView.trailingAnchor, constant: -10)
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
    
    public override func populate(nativeAd: GADNativeAd) {
        super.populate(nativeAd: nativeAd)
        visualTitleLbl.text = nativeAd.headline
    }
}

// MARK: - Live Canvas Preview
#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 15.0, *)
public struct NativeAppOpenLayoutView_Previews: PreviewProvider {
    public static var previews: some View {
        AppOpenPreviewContainer()
            .previewDisplayName("AppOpen Preview")
    }
    
    private struct AppOpenPreviewContainer: UIViewRepresentable {
        func makeUIView(context: Context) -> NativeAppOpenLayoutView {
            let view = NativeAppOpenLayoutView(layoutName: "native_appopen_media")
            view.headlineLbl.text = "Clash of Clans"
            view.advertiserLbl.text = "Supercell"
            view.callToActionBtn.setTitle("OPEN APP", for: .normal)
            view.iconImgView.backgroundColor = .systemBlue
            view.adMediaView.backgroundColor = UIColor(hex: "#D9D9D9")
            view.countdownLbl.text = "5s remaining..."
            return view
        }
        func updateUIView(_ uiView: NativeAppOpenLayoutView, context: Context) {}
    }
}
#endif
