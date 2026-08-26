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
            // MARK: - 1. NATIVE INTERSTITIAL
            /*
            // 1. Interstitial Media - Portrait
            PreviewContainer(layoutName: "native_inter_media")
                .ignoresSafeArea()
                .previewDisplayName("1. Interstitial Media - Portrait")
            
            // 2. Interstitial Media - Landscape
            PreviewContainer(layoutName: "native_inter_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("2. Interstitial Media - Landscape")
            
            // 3. Interstitial No-Media - Portrait
            PreviewContainer(layoutName: "native_inter_no_media")
                .ignoresSafeArea()
                .previewDisplayName("3. Interstitial No-Media - Portrait")
            
            // 4. Interstitial No-Media - Landscape
            PreviewContainer(layoutName: "native_inter_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("4. Interstitial No-Media - Landscape")
            
            // 5. Interstitial 2 Media - Portrait
            PreviewContainer(layoutName: "native_inter_media_2")
                .ignoresSafeArea()
                .previewDisplayName("5. Interstitial 2 Media - Portrait")
            
            // 6. Interstitial 2 Media - Landscape
            PreviewContainer(layoutName: "native_inter_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("6. Interstitial 2 Media - Landscape")
            
            // 7. Interstitial 2 No-Media - Portrait
            PreviewContainer(layoutName: "native_inter_no_media_2")
                .ignoresSafeArea()
                .previewDisplayName("7. Interstitial 2 No-Media - Portrait")
            
            // 8. Interstitial 2 No-Media - Landscape
            PreviewContainer(layoutName: "native_inter_no_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("8. Interstitial 2 No-Media - Landscape")
            */
            
            // MARK: - 2. NATIVE APPOPEN
            /*
            // 9. AppOpen Media - Portrait
            PreviewContainer(layoutName: "native_appopen_media")
                .ignoresSafeArea()
                .previewDisplayName("9. AppOpen Media - Portrait")
            
            // 10. AppOpen Media - Landscape
            PreviewContainer(layoutName: "native_appopen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("10. AppOpen Media - Landscape")
            
            // 11. AppOpen No-Media - Portrait
            PreviewContainer(layoutName: "native_appopen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("11. AppOpen No-Media - Portrait")
            
            // 12. AppOpen No-Media - Landscape
            PreviewContainer(layoutName: "native_appopen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("12. AppOpen No-Media - Landscape")
            */
            
            // MARK: - 3. NATIVE REWARD
            /*
            // 13. Reward Media - Portrait
            PreviewContainer(layoutName: "native_reward_media")
                .ignoresSafeArea()
                .previewDisplayName("13. Reward Media - Portrait")
            
            // 14. Reward Media - Landscape
            PreviewContainer(layoutName: "native_reward_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("14. Reward Media - Landscape")
            
            // 15. Reward No-Media - Portrait
            PreviewContainer(layoutName: "native_reward_no_media")
                .ignoresSafeArea()
                .previewDisplayName("15. Reward No-Media - Portrait")
            
            // 16. Reward No-Media - Landscape
            PreviewContainer(layoutName: "native_reward_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("16. Reward No-Media - Landscape")
            
            // 17. Reward 2 Media - Portrait
            PreviewContainer(layoutName: "native_reward_media_2")
                .ignoresSafeArea()
                .previewDisplayName("17. Reward 2 Media - Portrait")
            
            // 18. Reward 2 Media - Landscape
            PreviewContainer(layoutName: "native_reward_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("18. Reward 2 Media - Landscape")
            
            // 19. Reward 2 No-Media - Portrait
            PreviewContainer(layoutName: "native_reward_no_media_2")
                .ignoresSafeArea()
                .previewDisplayName("19. Reward 2 No-Media - Portrait")
            
            // 20. Reward 2 No-Media - Landscape
            PreviewContainer(layoutName: "native_reward_no_media_2")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("20. Reward 2 No-Media - Landscape")
            */
            
            // MARK: - 4. NATIVE HALF-SCREEN
            /*
            // 21. Half-Screen Media - Portrait
            PreviewContainer(layoutName: "native_halfscreen_media")
                .ignoresSafeArea()
                .previewDisplayName("21. Half-Screen Media - Portrait")
            
            // 22. Half-Screen Media - Landscape
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("22. Half-Screen Media - Landscape")
            
            // 23. Half-Screen No-Media - Portrait
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("23. Half-Screen No-Media - Portrait")
            
            // 24. Half-Screen No-Media - Landscape
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("24. Half-Screen No-Media - Landscape")
            */
            
            // MARK: - 5. OTHER FORMATS
            /*
            // 25. Native Banner - Portrait
            PreviewContainer(layoutName: "native_banner")
                .ignoresSafeArea()
                .previewDisplayName("25. Native Banner - Portrait")
            
            // 26. Native Banner - Landscape
            PreviewContainer(layoutName: "native_banner")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("26. Native Banner - Landscape")
            */
            
            // 27. Native MREC Media (300x250)
            PreviewContainer(layoutName: "native_mrec_media")
                .ignoresSafeArea()
                .previewDisplayName("27. Native MREC Media")
            
            // 28. Native MREC No-Media (300x250)
            PreviewContainer(layoutName: "native_mrec_no_media")
                .ignoresSafeArea()
                .previewDisplayName("28. Native MREC No-Media")
            
            /*
            // 29. Native Video (Màn Dọc)
            PreviewContainer(layoutName: "native_video")
                .ignoresSafeArea()
                .previewDisplayName("29. Video - Portrait")
            */
        }
    }
}

// MARK: - Wrapper hiển thị UIKit trong Canvas kèm Mock Data
private struct PreviewContainer: UIViewRepresentable {
    let layoutName: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        
        // Với Half-Screen, Banner và MREC, để nền trắng sạch sẽ để dễ nhìn phần trong suốt
        if layoutName.contains("halfscreen") || layoutName.contains("banner") || layoutName.contains("mrec") {
            container.backgroundColor = .white
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
        view.headlineLbl.text = "Google Ads"
        view.bodyLbl.text = "Make your business more visible!"
        view.advertiserLbl.text = "Make your business more visible!"
        view.callToActionBtn.setTitle("CONTINUE", for: .normal)
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
        if let mrecNoMedia = view as? NativeMrecNoMediaLayoutView {
            mrecNoMedia.largeIconImgView.backgroundColor = .systemBlue
        }
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif
