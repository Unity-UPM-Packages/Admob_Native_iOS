//
//  NativeFullScreenMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Fullscreen Media: MediaView chiếm toàn bộ phía trên, footer ở đáy chứa Icon, nhãn Ad, Headline, Advertiser và CTA.
//  Dùng chung 1 bố cục cho cả màn dọc và màn ngang.
//  Ánh xạ với Android: res/layout/native_fullscreen_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeFullScreenMediaLayoutView: BaseNativeAdLayoutView {

    // Nền footer kéo xuống tận đáy màn hình (che cả vùng home indicator)
    private let bottomCardView = UIView()
    // Vùng nội dung của footer, nằm trên home indicator
    private let footerGuide = UILayoutGuide()
    // Khối 2 dòng Headline + Advertiser, căn giữa theo chiều dọc trong footer
    private let textGuide = UILayoutGuide()

    public init() {
        super.init(frame: .zero)
        self.isLineFill = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func setupLayout() {
        backgroundColor = .gntBgDark
        let safe = safeAreaLayoutGuide

        // 1. MediaView chiếm toàn bộ phía trên đường phân cách
        adMediaView.contentMode = .scaleAspectFit
        adMediaView.backgroundColor = .clear
        addSubview(adMediaView)

        // 2. Đường phân cách giữa MediaView và footer (#505763)
        dividerView.backgroundColor = .gntBorderDark
        addSubview(dividerView)

        // 3. Nền footer
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = .gntBgDark
        addSubview(bottomCardView)

        // 4. Icon ứng dụng bên trái footer
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.layer.cornerRadius = 6
        addSubview(iconImgView)

        // 5. Nhãn Ad màu vàng
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsAdBadgeTextSize)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.textAlignment = .center
        addSubview(adBadgeLbl)

        // 6. Headline bên phải nhãn Ad, kéo dài tới nút CTA
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsHeadlineTextSize)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(headlineLbl)

        // 7. Advertiser (dòng thứ hai)
        advertiserLbl.textColor = .gntSecondaryText
        advertiserLbl.font = UIFont.systemFont(ofSize: LayoutDimensions.fsSecondaryTextSize)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        advertiserLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(advertiserLbl)

        // 8. Nút CTA bên phải footer
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.layer.borderWidth = 0
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsCtaTextSize)
        addSubview(callToActionBtn)

        // 9. Nút Skip dạng Pill sát mép phải
        applySkipPillStyle()
        addSubview(closeButton)

        // 10. Thanh progress đếm ngược màu vàng sát mép trên
        progressBar.isHidden = true
        addSubview(progressBar)

        addLayoutGuide(footerGuide)
        addLayoutGuide(textGuide)

        NSLayoutConstraint.activate([
            // Progress bar
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),

            // Footer: nội dung nằm trên home indicator, nền kéo tới đáy màn hình
            footerGuide.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            footerGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerGuide.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsBarHeight),

            bottomCardView.topAnchor.constraint(equalTo: footerGuide.topAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Divider ngay trên footer
            dividerView.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            // MediaView chiếm toàn bộ phía trên divider
            adMediaView.bottomAnchor.constraint(equalTo: dividerView.topAnchor),
            adMediaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adMediaView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Icon bên trái footer
            iconImgView.leadingAnchor.constraint(equalTo: footerGuide.leadingAnchor, constant: 16),
            iconImgView.centerYAnchor.constraint(equalTo: footerGuide.centerYAnchor),
            iconImgView.widthAnchor.constraint(equalToConstant: LayoutDimensions.fsIconSize),
            iconImgView.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsIconSize),

            // CTA bên phải footer
            callToActionBtn.trailingAnchor.constraint(equalTo: footerGuide.trailingAnchor, constant: -16),
            callToActionBtn.centerYAnchor.constraint(equalTo: footerGuide.centerYAnchor),
            callToActionBtn.widthAnchor.constraint(equalToConstant: LayoutDimensions.fsCtaWidth),
            callToActionBtn.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsCtaHeight),

            // Khối Headline + Advertiser căn giữa theo chiều dọc trong footer
            textGuide.centerYAnchor.constraint(equalTo: footerGuide.centerYAnchor),

            // Nhãn Ad: bên phải Icon, căn giữa theo Headline
            adBadgeLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 12),
            adBadgeLbl.centerYAnchor.constraint(equalTo: headlineLbl.centerYAnchor),
            adBadgeLbl.widthAnchor.constraint(equalToConstant: LayoutDimensions.fsAdBadgeWidth),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsAdBadgeHeight),

            // Headline: bên phải nhãn Ad, kéo dài tới CTA
            headlineLbl.topAnchor.constraint(equalTo: textGuide.topAnchor),
            headlineLbl.leadingAnchor.constraint(equalTo: adBadgeLbl.trailingAnchor, constant: 8),
            headlineLbl.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),

            // Advertiser: dòng dưới, thẳng hàng với nhãn Ad
            advertiserLbl.topAnchor.constraint(equalTo: headlineLbl.bottomAnchor),
            advertiserLbl.bottomAnchor.constraint(equalTo: textGuide.bottomAnchor),
            advertiserLbl.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 12),
            advertiserLbl.trailingAnchor.constraint(equalTo: callToActionBtn.leadingAnchor, constant: -12),

            // Nút Skip: sát mép phải thật của màn hình (kể cả màn ngang)
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // PORTRAIT: phần trên bám vùng an toàn để tránh tai thỏ / Dynamic Island
        portraitConstraints = [
            progressBar.topAnchor.constraint(equalTo: safe.topAnchor),
            adMediaView.topAnchor.constraint(equalTo: safe.topAnchor),
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: LayoutDimensions.skipMarginTop)
        ]

        // LANDSCAPE: phần trên bám mép thật của view (giống Android), không phụ thuộc vùng an toàn,
        // để ad được tạo lúc app đang bị App Store che / chạy nền không bị đẩy xuống
        landscapeConstraints = [
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            adMediaView.topAnchor.constraint(equalTo: topAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: LayoutDimensions.skipMarginTop)
        ]

        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)

        updateOrientationConstraints()
    }
}
