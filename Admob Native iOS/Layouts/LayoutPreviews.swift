//
//  LayoutPreviews.swift
//  Admob Native iOS
//
//  Live SwiftUI Canvas Previews cho Xcode (Hỗ trợ xem trước tất cả layout UIKit cả Portrait & Landscape).
//

#if DEBUG
import SwiftUI
import UIKit

// MARK: - 1. PREVIEW NATIVE INTERSTITIAL (DỌC & NGANG)
#Preview("Native Interstitial - Portrait") {
    PreviewContainer(layoutName: "native_inter_media")
}

#Preview("Native Interstitial - Landscape", traits: .landscapeLeft) {
    PreviewContainer(layoutName: "native_inter_media")
}

// MARK: - 2. PREVIEW APPOPEN (HIGH-CTR)
#Preview("Native AppOpen - Portrait") {
    PreviewContainer(layoutName: "native_appopen_media")
}

// MARK: - 3. PREVIEW REWARD (SPLIT DARK V2)
#Preview("Native Reward - Portrait") {
    PreviewContainer(layoutName: "native_reward_media_2")
}

// MARK: - 4. PREVIEW HALF-SCREEN (DỌC & NGANG)
#Preview("Native Half-Screen - Portrait") {
    PreviewContainer(layoutName: "native_halfscreen_media")
}

#Preview("Native Half-Screen - Landscape", traits: .landscapeLeft) {
    PreviewContainer(layoutName: "native_halfscreen_media")
}

// MARK: - 5. PREVIEW NATIVE BANNER & MREC
#Preview("Native Banner") {
    PreviewContainer(layoutName: "native_banner")
        .frame(height: 70)
}

#Preview("Native MREC") {
    PreviewContainer(layoutName: "native_mrec_media")
        .frame(width: 320, height: 260)
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
