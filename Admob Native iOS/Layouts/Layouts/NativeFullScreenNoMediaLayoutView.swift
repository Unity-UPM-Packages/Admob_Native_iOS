//
//  NativeFullScreenNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Fullscreen No-Media (Icon lớn thay cho MediaView).
//  - Màn dọc: header trên cùng (nhãn Ad, Headline, Advertiser) + divider, Icon lớn ở giữa, CTA kéo dài ở đáy.
//  - Màn ngang: chia đôi 50/50, nửa trái Icon lớn, nửa phải header + divider ở trên và CTA ở dưới.
//  Headline kéo tới mép phải và nằm dưới nút Skip.
//  Ánh xạ với Android: res/layout/native_fullscreen_no_media.xml & res/layout-land/native_fullscreen_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeFullScreenNoMediaLayoutView: BaseNativeAdLayoutView {

    // Icon lớn thay cho MediaView
    public let largeIconImgView = UIImageView()

    // Nền header và footer
    private let topCardView = UIView()
    private let bottomCardView = UIView()
    // Đường phân cách dọc giữa 2 nửa (chỉ hiện ở màn ngang)
    private let centerDividerView = UIView()

    // Vùng nội dung footer (nằm trên home indicator)
    private let footerGuide = UILayoutGuide()
    // Khối 2 dòng Headline + Advertiser, căn giữa theo chiều dọc trong header
    private let textGuide = UILayoutGuide()
    // Vùng chứa Icon lớn
    private let iconAreaGuide = UILayoutGuide()

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

        // 1. Nền header & footer
        topCardView.translatesAutoresizingMaskIntoConstraints = false
        topCardView.backgroundColor = .gntBgDark
        addSubview(topCardView)

        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        bottomCardView.backgroundColor = .gntBgDark
        addSubview(bottomCardView)

        // 2. Các đường phân cách (#505763)
        dividerView.backgroundColor = .gntBorderDark
        addSubview(dividerView)

        centerDividerView.translatesAutoresizingMaskIntoConstraints = false
        centerDividerView.backgroundColor = .gntBorderDark
        centerDividerView.isHidden = true
        addSubview(centerDividerView)

        // 3. Icon lớn
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 24
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        addSubview(largeIconImgView)

        // 4. Nút CTA
        callToActionBtn.backgroundColor = .gntCtaBlue
        callToActionBtn.layer.borderWidth = 0
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsCtaTextSize)
        addSubview(callToActionBtn)

        // 5. Nhãn Ad màu vàng
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsAdBadgeTextSize)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.textAlignment = .center
        addSubview(adBadgeLbl)

        // 6. Headline (kéo tới mép phải, nằm dưới nút Skip)
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: LayoutDimensions.fsHeadlineTextSize)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(headlineLbl)

        // 7. Advertiser
        advertiserLbl.textColor = .gntSecondaryText
        advertiserLbl.font = UIFont.systemFont(ofSize: LayoutDimensions.fsSecondaryTextSize)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        advertiserLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(advertiserLbl)

        // 8. Nút Skip dạng Pill sát mép phải (khai báo sau Headline + zPosition để luôn nằm trên)
        applySkipPillStyle()
        addSubview(closeButton)

        // Headline/Advertiser vẫn kéo dài tới mép (vùng click), nhưng chữ cắt "..." trước nút Skip
        let skipReserveWidth = closeButton.intrinsicContentSize.width + 8
        headlineLbl.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: skipReserveWidth)
        advertiserLbl.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: max(0, skipReserveWidth - 12))

        // 9. Thanh progress đếm ngược màu vàng sát mép trên
        progressBar.isHidden = true
        addSubview(progressBar)

        addLayoutGuide(footerGuide)
        addLayoutGuide(textGuide)
        addLayoutGuide(iconAreaGuide)

        let barHeight = LayoutDimensions.fsBarHeight
        let iconSize = LayoutDimensions.fsNoMediaIconSize
        let sideMargin = LayoutDimensions.fsSideMargin

        // Constraints dùng chung cho cả 2 hướng màn hình
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),

            // Header ở trên cùng
            topCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topCardView.heightAnchor.constraint(equalToConstant: barHeight),

            dividerView.topAnchor.constraint(equalTo: topCardView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            // Footer: nội dung nằm trên home indicator, nền kéo tới đáy màn hình
            footerGuide.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor),
            footerGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerGuide.heightAnchor.constraint(equalToConstant: barHeight),

            bottomCardView.topAnchor.constraint(equalTo: footerGuide.topAnchor),
            bottomCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCardView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Đường phân cách dọc ở giữa màn hình
            centerDividerView.topAnchor.constraint(equalTo: topAnchor),
            centerDividerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            centerDividerView.leadingAnchor.constraint(equalTo: centerXAnchor),
            centerDividerView.widthAnchor.constraint(equalToConstant: 1),

            // Icon lớn căn giữa vùng chứa
            largeIconImgView.centerXAnchor.constraint(equalTo: iconAreaGuide.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: iconAreaGuide.centerYAnchor),
            largeIconImgView.widthAnchor.constraint(equalToConstant: iconSize),
            largeIconImgView.heightAnchor.constraint(equalToConstant: iconSize),

            // CTA kéo dài hết chiều ngang footer, cách lề 20
            callToActionBtn.leadingAnchor.constraint(equalTo: footerGuide.leadingAnchor, constant: 20),
            callToActionBtn.trailingAnchor.constraint(equalTo: footerGuide.trailingAnchor, constant: -20),
            callToActionBtn.centerYAnchor.constraint(equalTo: footerGuide.centerYAnchor),
            callToActionBtn.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsCtaHeight),

            // Khối Headline + Advertiser căn giữa theo chiều dọc trong header
            textGuide.centerYAnchor.constraint(equalTo: topCardView.centerYAnchor),

            adBadgeLbl.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: sideMargin),
            adBadgeLbl.centerYAnchor.constraint(equalTo: headlineLbl.centerYAnchor),
            adBadgeLbl.widthAnchor.constraint(equalToConstant: LayoutDimensions.fsAdBadgeWidth),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: LayoutDimensions.fsAdBadgeHeight),

            headlineLbl.topAnchor.constraint(equalTo: textGuide.topAnchor),
            headlineLbl.leadingAnchor.constraint(equalTo: adBadgeLbl.trailingAnchor, constant: 8),
            headlineLbl.trailingAnchor.constraint(equalTo: trailingAnchor),

            advertiserLbl.topAnchor.constraint(equalTo: headlineLbl.bottomAnchor),
            advertiserLbl.bottomAnchor.constraint(equalTo: textGuide.bottomAnchor),
            advertiserLbl.leadingAnchor.constraint(equalTo: topCardView.leadingAnchor, constant: sideMargin),
            advertiserLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            // Nút Skip: sát mép phải thật của màn hình (kể cả màn ngang)
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        // PORTRAIT: header, divider, footer trải hết chiều ngang; Icon nằm giữa divider và footer.
        // Phần trên bám vùng an toàn để tránh tai thỏ / Dynamic Island
        portraitConstraints = [
            progressBar.topAnchor.constraint(equalTo: safe.topAnchor),
            topCardView.topAnchor.constraint(equalTo: safe.topAnchor),
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: LayoutDimensions.skipMarginTop),
            footerGuide.bottomAnchor.constraint(equalTo: safe.bottomAnchor),

            topCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCardView.leadingAnchor.constraint(equalTo: leadingAnchor),

            iconAreaGuide.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            iconAreaGuide.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor),
            iconAreaGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconAreaGuide.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        // LANDSCAPE: nửa phải chứa header, divider và footer; nửa trái chứa Icon.
        // Phần trên bám mép thật của view (giống Android), không phụ thuộc vùng an toàn,
        // để ad được tạo lúc app đang bị App Store che / chạy nền không bị đẩy xuống
        landscapeConstraints = [
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            topCardView.topAnchor.constraint(equalTo: topAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: LayoutDimensions.skipMarginTop),
            footerGuide.bottomAnchor.constraint(equalTo: bottomAnchor),

            topCardView.leadingAnchor.constraint(equalTo: centerDividerView.trailingAnchor),
            bottomCardView.leadingAnchor.constraint(equalTo: centerDividerView.trailingAnchor),

            iconAreaGuide.topAnchor.constraint(equalTo: topAnchor),
            iconAreaGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconAreaGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconAreaGuide.trailingAnchor.constraint(equalTo: centerDividerView.leadingAnchor)
        ]

        bringSubviewToFront(closeButton)
        bringSubviewToFront(progressBar)

        updateOrientationConstraints()
    }

    public override func updateOrientationConstraints() {
        super.updateOrientationConstraints()
        guard bounds.width > 0 && bounds.height > 0 else { return }
        centerDividerView.isHidden = bounds.width <= bounds.height
    }

    public override func populate(nativeAd: GADNativeAd) {
        self.mediaView = nil
        self.imageView = nil
        super.populate(nativeAd: nativeAd)
        if let icon = nativeAd.icon {
            largeIconImgView.image = icon.image
            largeIconImgView.isHidden = false
        }
        self.iconView = largeIconImgView
    }
}
