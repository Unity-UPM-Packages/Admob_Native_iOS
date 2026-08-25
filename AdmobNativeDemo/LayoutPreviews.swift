//
//  LayoutPreviews.swift
//  Admob Native iOS
//
//  Live SwiftUI Canvas Previews cho Xcode - Dành cho Target App AdmobNativeDemo.
//

#if DEBUG
import SwiftUI
import UIKit
import GoogleMobileAds
import Admob_Native_iOS

@available(iOS 15.0, *)
public struct LayoutPreviews_Previews: PreviewProvider {
    public static var previews: some View {
        Group {
            // 1. Native Interstitial (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_inter_media")
                .ignoresSafeArea()
                .previewDisplayName("1. Interstitial Media - Portrait")
            
            // 2. Native Interstitial (Media - Màn Ngang)
            PreviewContainer(layoutName: "native_inter_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("2. Interstitial Media - Landscape")
            
            // 3. Native Interstitial (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_inter_no_media")
                .ignoresSafeArea()
                .previewDisplayName("3. Interstitial No-Media - Portrait")
            
            // 4. Native Interstitial (No-Media - Màn Ngang)
            PreviewContainer(layoutName: "native_inter_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("4. Interstitial No-Media - Landscape")
            
            // 5. Native AppOpen (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_appopen_media")
                .ignoresSafeArea()
                .previewDisplayName("5. AppOpen Media - Portrait")
            
            // 6. Native AppOpen (Media - Màn Ngang)
            PreviewContainer(layoutName: "native_appopen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("6. AppOpen Media - Landscape")
            
            // 7. Native AppOpen (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_appopen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("7. AppOpen No-Media - Portrait")
            
            // 8. Native AppOpen (No-Media - Màn Ngang)
            PreviewContainer(layoutName: "native_appopen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("8. AppOpen No-Media - Landscape")
            
            // 4. Native Reward (Split Dark V2)
            PreviewContainer(layoutName: "native_reward_media_2")
                .ignoresSafeArea()
                .previewDisplayName("4. Reward - Split Dark")
            
            // 5. Native Half-Screen (Màn Dọc)
            PreviewContainer(layoutName: "native_halfscreen_media")
                .ignoresSafeArea()
                .previewDisplayName("5. Half-Screen - Portrait")
            
            // 6. Native Half-Screen (Màn Ngang)
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("6. Half-Screen - Landscape")
            
            // 7. Native Banner (Bottom Bar)
            PreviewContainer(layoutName: "native_banner")
                .frame(height: 70)
                .previewDisplayName("7. Native Banner")
            
            // 8. Native MREC (300x250)
            PreviewContainer(layoutName: "native_mrec_media")
                .frame(width: 320, height: 260)
                .previewDisplayName("8. Native MREC")
            
            // 9. Native Video (Màn Dọc)
            PreviewContainer(layoutName: "native_video")
                .ignoresSafeArea()
                .previewDisplayName("9. Video - Portrait")
        }
    }
}

// MARK: - Wrapper hiển thị UIKit trong Canvas kèm Mock Data
private struct PreviewContainer: UIViewRepresentable {
    let layoutName: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(hex: "#101826")
        
        let view = NativeLayoutFactory.createLayout(layoutName: layoutName)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        // Mock dữ liệu mẫu để render giao diện trực quan trong Canvas
        view.headlineLbl.text = "Clash of Clans: Epic Battles"
        view.bodyLbl.text = "Lead your clan to victory in legendary strategy wars!"
        view.advertiserLbl.text = "Supercell Games"
        view.callToActionBtn.setTitle("INSTALL NOW", for: .normal)
        view.iconImgView.backgroundColor = .systemBlue
        view.adMediaView.backgroundColor = UIColor(hex: "#2A2D34")
        view.countdownLbl.text = "5s remaining..."
        view.progressBar.progress = 0.4
        
        if let interNoMedia = view as? NativeInterNoMediaLayoutView {
            interNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let appOpenNoMedia = view as? NativeAppOpenNoMediaLayoutView {
            appOpenNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif
