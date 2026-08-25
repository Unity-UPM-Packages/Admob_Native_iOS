//
//  NativeMrecLayoutView.swift
//  Admob Native iOS
//
//  Layout Medium Rectangle (300x250) chuẩn AdMob.
//

import UIKit
import GoogleMobileAds

public final class NativeMrecLayoutView: BaseNativeAdLayoutView {
    
    private let isNoMediaVariant: Bool
    
    public init(layoutName: String = "native_mrec_media") {
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
        cardContainerView.layer.borderColor = UIColor.gntBorderDark.cgColor
        cardContainerView.layer.borderWidth = 1
        
        addSubview(cardContainerView)
        
        let mediaOrImage = isNoMediaVariant ? mainImgView : adMediaView
        cardContainerView.addSubview(mediaOrImage)
        
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
        titleRow.spacing = 6
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        textStack.addArrangedSubview(titleRow)
        textStack.addArrangedSubview(bodyLbl)
        
        footerStack.addArrangedSubview(textStack)
        footerStack.addArrangedSubview(callToActionBtn)
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mediaOrImage.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 8),
            mediaOrImage.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 8),
            mediaOrImage.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8),
            mediaOrImage.bottomAnchor.constraint(equalTo: footerStack.topAnchor, constant: -6),
            
            footerStack.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 8),
            footerStack.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8),
            footerStack.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -8),
            footerStack.heightAnchor.constraint(equalToConstant: 44),
            
            iconImgView.widthAnchor.constraint(equalToConstant: 40),
            iconImgView.heightAnchor.constraint(equalToConstant: 40),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 22),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 14),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: 80),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

// MARK: - Live Canvas Preview
#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 15.0, *)
public struct NativeMrecLayoutView_Previews: PreviewProvider {
    public static var previews: some View {
        MrecPreviewContainer()
            .frame(width: 320, height: 260)
            .previewDisplayName("MREC Preview")
    }
    
    private struct MrecPreviewContainer: UIViewRepresentable {
        func makeUIView(context: Context) -> NativeMrecLayoutView {
            let view = NativeMrecLayoutView()
            view.headlineLbl.text = "Epic Strategy"
            view.bodyLbl.text = "Join over 1M players worldwide!"
            view.callToActionBtn.setTitle("PLAY", for: .normal)
            view.iconImgView.backgroundColor = .systemBlue
            view.adMediaView.backgroundColor = UIColor(hex: "#D9D9D9")
            return view
        }
        func updateUIView(_ uiView: NativeMrecLayoutView, context: Context) {}
    }
}
#endif
