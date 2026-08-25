//
//  LayoutPreviews.swift
//  Admob Native iOS
//
//  Live SwiftUI Canvas Previews cho Xcode (Tương thích chuẩn từ iOS 15.0+ trở lên).
//

#if DEBUG
import SwiftUI
import UIKit

@available(iOS 15.0, *)
public struct LayoutPreviews_Previews: PreviewProvider {
    public static var previews: some View {
        Group {
            PreviewContainer(layoutName: "native_inter_media")
                .previewDisplayName("Native Interstitial - Portrait")
            
            PreviewContainer(layoutName: "native_inter_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Native Interstitial - Landscape")
            
            PreviewContainer(layoutName: "native_appopen_media")
                .previewDisplayName("Native AppOpen - Portrait")
            
            PreviewContainer(layoutName: "native_reward_media_2")
                .previewDisplayName("Native Reward - Portrait")
            
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewDisplayName("Native Half-Screen - Portrait")
            
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("Native Half-Screen - Landscape")
            
            PreviewContainer(layoutName: "native_banner")
                .frame(height: 70)
                .previewDisplayName("Native Banner")
            
            PreviewContainer(layoutName: "native_mrec_media")
                .frame(width: 320, height: 260)
                .previewDisplayName("Native MREC")
        }
    }
}

// MARK: - Wrapper hiển thị UIKit trong Canvas & Mock Data
private struct PreviewContainer: UIViewRepresentable {
    let layoutName: String
    
    func makeUIView(context: Context) -> BaseNativeAdLayoutView {
        let view = NativeLayoutFactory.createLayout(layoutName: layoutName)
        
        // Mock dữ liệu mẫu để render giao diện trực quan trong Canvas Xcode
        view.headlineLbl.text = "Clash of Clans: Epic Battles"
        view.bodyLbl.text = "Lead your clan to victory in legendary strategy wars!"
        view.advertiserLbl.text = "Supercell Games"
        view.callToActionBtn.setTitle("INSTALL NOW", for: .normal)
        view.iconImgView.backgroundColor = .systemBlue
        view.adMediaView.backgroundColor = UIColor(hex: "#D9D9D9")
        view.countdownLbl.text = "5s remaining..."
        view.progressBar.progress = 0.4
        
        return view
    }
    
    func updateUIView(_ uiView: BaseNativeAdLayoutView, context: Context) {}
}
#endif
