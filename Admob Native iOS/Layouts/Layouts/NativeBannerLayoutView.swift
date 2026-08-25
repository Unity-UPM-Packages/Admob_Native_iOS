//
//  NativeBannerLayoutView.swift
//  Admob Native iOS
//
//  Layout Native Banner nhỏ dạng bar đính cạnh màn hình (Bottom/Top).
//

import UIKit
import GoogleMobileAds

public final class NativeBannerLayoutView: BaseNativeAdLayoutView {
    
    public init(layoutName: String = "native_banner") {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func setupLayout() {
        backgroundColor = .clear
        
        cardContainerView.backgroundColor = .gntBgNativeBanner
        cardContainerView.layer.cornerRadius = 0 // Banner tràn viền cạnh dưới
        
        addSubview(cardContainerView)
        
        let contentStack = UIStackView()
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 10
        cardContainerView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(iconImgView)
        
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
        
        contentStack.addArrangedSubview(textStack)
        contentStack.addArrangedSubview(callToActionBtn)
        
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 8),
            contentStack.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -8),
            contentStack.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 4),
            contentStack.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -4),
            
            iconImgView.widthAnchor.constraint(equalToConstant: 44),
            iconImgView.heightAnchor.constraint(equalToConstant: 44),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 22),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 14),
            
            callToActionBtn.widthAnchor.constraint(equalToConstant: 100),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

// MARK: - Live Canvas Preview
#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available(iOS 15.0, *)
public struct NativeBannerLayoutView_Previews: PreviewProvider {
    public static var previews: some View {
        BannerPreviewContainer()
            .frame(height: 70)
            .previewDisplayName("Banner Preview")
    }
    
    private struct BannerPreviewContainer: UIViewRepresentable {
        func makeUIView(context: Context) -> NativeBannerLayoutView {
            let view = NativeBannerLayoutView()
            view.headlineLbl.text = "Clash of Clans"
            view.bodyLbl.text = "Build your village & battle!"
            view.callToActionBtn.setTitle("INSTALL", for: .normal)
            view.iconImgView.backgroundColor = .systemBlue
            return view
        }
        func updateUIView(_ uiView: NativeBannerLayoutView, context: Context) {}
    }
}
#endif
