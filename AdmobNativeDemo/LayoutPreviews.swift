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
            
            // 4a. Native Interstitial 2 (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_inter_media_2")
                .ignoresSafeArea()
                .previewDisplayName("4a. Interstitial 2 Media - Portrait")
            
            // 4b. Native Interstitial 2 (Media - Màn Ngang 50/50)
            PreviewContainer(layoutName: "native_inter_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("4b. Interstitial 2 Media - Landscape")
            
            // 4c. Native Interstitial 2 (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_inter_no_media_2")
                .ignoresSafeArea()
                .previewDisplayName("4c. Interstitial 2 No-Media - Portrait")
            
            // 4d. Native Interstitial 2 (No-Media - Màn Ngang 50/50)
            PreviewContainer(layoutName: "native_inter_no_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("4d. Interstitial 2 No-Media - Landscape")
            
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
            
            // 9. Native Reward (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_reward_media")
                .ignoresSafeArea()
                .previewDisplayName("9. Reward Media - Portrait")
            
            // 10. Native Reward (Media - Màn Ngang)
            PreviewContainer(layoutName: "native_reward_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("10. Reward Media - Landscape")
            
            // 11. Native Reward (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_reward_no_media")
                .ignoresSafeArea()
                .previewDisplayName("11. Reward No-Media - Portrait")
            
            // 12. Native Reward (No-Media - Màn Ngang)
            PreviewContainer(layoutName: "native_reward_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("12. Reward No-Media - Landscape")
            
            // 12a. Native Reward 2 (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_reward_media_2")
                .ignoresSafeArea()
                .previewDisplayName("12a. Reward 2 Media - Portrait")
            
            // 12b. Native Reward 2 (Media - Màn Ngang)
            PreviewContainer(layoutName: "native_reward_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("12b. Reward 2 Media - Landscape")
            
            // 12c. Native Reward 2 (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_reward_no_media_2")
                .ignoresSafeArea()
                .previewDisplayName("12c. Reward 2 No-Media - Portrait")
            
            // 12d. Native Reward 2 (No-Media - Màn Ngang)
            PreviewContainer(layoutName: "native_reward_no_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("12d. Reward 2 No-Media - Landscape")
            
            // 13. Native Half-Screen (Media - Màn Dọc)
            PreviewContainer(layoutName: "native_halfscreen_media")
                .ignoresSafeArea()
                .previewDisplayName("13. Half-Screen Media - Portrait")
            
            // 14. Native Half-Screen (Media - Màn Ngang)
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("14. Half-Screen Media - Landscape")
            
            // 14a. Native Half-Screen (No-Media - Màn Dọc)
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("14a. Half-Screen No-Media - Portrait")
            
            // 14b. Native Half-Screen (No-Media - Màn Ngang)
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("14b. Half-Screen No-Media - Landscape")
            
            // 15. Native Banner (Bottom Bar)
            PreviewContainer(layoutName: "native_banner")
                .frame(height: 70)
                .previewDisplayName("15. Native Banner")
            
            // 16. Native MREC (300x250)
            PreviewContainer(layoutName: "native_mrec_media")
                .frame(width: 320, height: 260)
                .previewDisplayName("16. Native MREC")
            
            // 17. Native Video (Màn Dọc)
            PreviewContainer(layoutName: "native_video")
                .ignoresSafeArea()
                .previewDisplayName("17. Video - Portrait")
        }
    }
}

// MARK: - Wrapper hiển thị UIKit trong Canvas kèm Mock Data
private struct PreviewContainer: UIViewRepresentable {
    let layoutName: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        
        // Nếu là Half-Screen, tạo nền giả lập Game Screen phía sau để thấy rõ hiệu ứng trong suốt
        if layoutName.contains("halfscreen") {
            container.backgroundColor = UIColor(hex: "#1E293B")
            
            let gameMockupLbl = UILabel()
            gameMockupLbl.translatesAutoresizingMaskIntoConstraints = false
            gameMockupLbl.text = "🎮 GAMEPLAY SCREEN\n(Interactive Area)"
            gameMockupLbl.textColor = UIColor.white.withAlphaComponent(0.6)
            gameMockupLbl.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
            gameMockupLbl.numberOfLines = 2
            gameMockupLbl.textAlignment = .center
            container.addSubview(gameMockupLbl)
            
            NSLayoutConstraint.activate([
                gameMockupLbl.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                gameMockupLbl.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        } else {
            container.backgroundColor = UIColor(hex: "#101826")
        }
        
        let view = NativeLayoutFactory.createLayout(layoutName: layoutName)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        // Mock dữ liệu mẫu thuần tuý (text/progress) để render Canvas
        view.headlineLbl.text = "Quảng cáo thử nghiệm"
        view.bodyLbl.text = "Lead your clan to victory in legendary strategy wars!"
        view.advertiserLbl.text = "Install Flood-It App for free!"
        view.callToActionBtn.setTitle("INSTALL", for: .normal)
        view.iconImgView.backgroundColor = .systemBlue
        view.countdownLbl.text = "5"
        view.progressBar.progress = 0.4
        
        if let interNoMedia = view as? NativeInterNoMediaLayoutView {
            interNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let inter2NoMedia = view as? NativeInterNoMedia2LayoutView {
            inter2NoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let appOpenNoMedia = view as? NativeAppOpenNoMediaLayoutView {
            appOpenNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let rewardNoMedia = view as? NativeRewardNoMediaLayoutView {
            rewardNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let reward2NoMedia = view as? NativeRewardNoMedia2LayoutView {
            reward2NoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        if let halfScreenNoMedia = view as? NativeHalfScreenNoMediaLayoutView {
            halfScreenNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif
