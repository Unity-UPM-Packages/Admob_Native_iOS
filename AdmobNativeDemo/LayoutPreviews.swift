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
            // MARK: - 1. NATIVE FULL SCREEN
            /*
            // 1. Full Screen Media - Portrait
            PreviewContainer(layoutName: "native_fullscreen_media")
                .ignoresSafeArea()
                .previewDisplayName("1. Full Screen Media - Portrait")

            // 2. Full Screen Media - Landscape
            PreviewContainer(layoutName: "native_fullscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("2. Full Screen Media - Landscape")

            // 3. Full Screen No-Media - Portrait
            PreviewContainer(layoutName: "native_fullscreen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("3. Full Screen No-Media - Portrait")

            // 4. Full Screen No-Media - Landscape
            PreviewContainer(layoutName: "native_fullscreen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("4. Full Screen No-Media - Landscape")
            */

            // MARK: - 2. NATIVE HALF-SCREEN
            /*
            // 5. Half-Screen Media - Portrait
            PreviewContainer(layoutName: "native_halfscreen_media")
                .ignoresSafeArea()
                .previewDisplayName("5. Half-Screen Media - Portrait")

            // 6. Half-Screen Media - Landscape
            PreviewContainer(layoutName: "native_halfscreen_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("6. Half-Screen Media - Landscape")

            // 7. Half-Screen No-Media - Portrait
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .ignoresSafeArea()
                .previewDisplayName("7. Half-Screen No-Media - Portrait")

            // 8. Half-Screen No-Media - Landscape
            PreviewContainer(layoutName: "native_halfscreen_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("8. Half-Screen No-Media - Landscape")
            */

            // MARK: - 3. OTHER FORMATS
            /*
            // 9. Native Banner - Portrait
            PreviewContainer(layoutName: "native_banner")
                .ignoresSafeArea()
                .previewDisplayName("9. Native Banner - Portrait")

            // 10. Native Banner - Landscape
            PreviewContainer(layoutName: "native_banner")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("10. Native Banner - Landscape")
            */

            // 11. Native MREC Media - Portrait
            PreviewContainer(layoutName: "native_mrec_media")
                .ignoresSafeArea()
                .previewDisplayName("11. Native MREC Media - Portrait")

            // 12. Native MREC Media - Landscape
            PreviewContainer(layoutName: "native_mrec_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("12. Native MREC Media - Landscape")

            // 13. Native MREC No-Media - Portrait
            PreviewContainer(layoutName: "native_mrec_no_media")
                .ignoresSafeArea()
                .previewDisplayName("13. Native MREC No-Media - Portrait")

            // 14. Native MREC No-Media - Landscape
            PreviewContainer(layoutName: "native_mrec_no_media")
                .previewInterfaceOrientation(.landscapeLeft)
                .ignoresSafeArea()
                .previewDisplayName("14. Native MREC No-Media - Landscape")

            /*
            // 15. Native Video (Màn Dọc)
            PreviewContainer(layoutName: "native_video")
                .ignoresSafeArea()
                .previewDisplayName("15. Video - Portrait")
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

        // Hiện sẵn nút Skip và progress để xem vị trí đè lên Headline
        if layoutName.contains("fullscreen") {
            view.closeButton.isHidden = false
            view.progressBar.isHidden = false
        }

        if let fullScreenNoMedia = view as? NativeFullScreenNoMediaLayoutView {
            fullScreenNoMedia.largeIconImgView.backgroundColor = .systemBlue
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
