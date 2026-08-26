//
//  NativeMrecMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native MREC Media (300x250pt), nền #0E2139, CTA màu #C9FF23.
//  Từ dưới lên: CTA -> Cụm Text ([Ad] + Headline + Body) -> MediaView (16:9).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_mrec_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeMrecMediaLayoutView: BaseNativeAdLayoutView {
    
    // Card MREC kích thước cố định 300x250pt
    private let mrecCardView = UIView()
    
    // Cụm Text
    private let infoBar = UIStackView()
    private let titleRow = UIStackView()
    
    public init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Cho phép touch xuyên qua phần màn hình trống bên ngoài khung MREC 300x250
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
    
    public override func setupLayout() {
        backgroundColor = .clear
        
        // 1. Khung MREC Card (300x250pt, màu #0E2139)
        mrecCardView.translatesAutoresizingMaskIntoConstraints = false
        mrecCardView.backgroundColor = UIColor(hex: "#0E2139")
        mrecCardView.layer.cornerRadius = 6
        mrecCardView.clipsToBounds = true
        addSubview(mrecCardView)
        
        // 2. MediaView (Tỉ lệ 16:9 ở phía trên, nền #E0E0E0, bo góc 4pt)
        adMediaView.translatesAutoresizingMaskIntoConstraints = false
        adMediaView.contentMode = .scaleAspectFit
        adMediaView.backgroundColor = UIColor(hex: "#E0E0E0")
        adMediaView.layer.cornerRadius = 4
        adMediaView.clipsToBounds = true
        mrecCardView.addSubview(adMediaView)
        
        // 3. Nhãn Ad màu vàng chữ nâu
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        // 4. Headline (chữ trắng in đậm)
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 14)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // 5. Body/Advertiser (chữ xám #B6BCC3)
        bodyLbl.translatesAutoresizingMaskIntoConstraints = false
        bodyLbl.textColor = UIColor(hex: "#B6BCC3")
        bodyLbl.font = UIFont.systemFont(ofSize: 12)
        bodyLbl.numberOfLines = 1
        bodyLbl.lineBreakMode = .byTruncatingTail
        
        // 6. Cấu hình Cụm Info Bar (2 dòng: Dòng 1 [Ad] + Headline, Dòng 2 Body)
        titleRow.translatesAutoresizingMaskIntoConstraints = false
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 6
        titleRow.addArrangedSubview(adBadgeLbl)
        titleRow.addArrangedSubview(headlineLbl)
        
        infoBar.translatesAutoresizingMaskIntoConstraints = false
        infoBar.axis = .vertical
        infoBar.alignment = .leading
        infoBar.spacing = 2
        infoBar.addArrangedSubview(titleRow)
        infoBar.addArrangedSubview(bodyLbl)
        mrecCardView.addSubview(infoBar)
        
        // 7. Nút CTA xanh dương (#1A73E8, chữ trắng) ở dưới cùng
        callToActionBtn.translatesAutoresizingMaskIntoConstraints = false
        callToActionBtn.backgroundColor = UIColor(hex: "#1A73E8")
        callToActionBtn.setTitleColor(.white, for: .normal)
        callToActionBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        callToActionBtn.layer.cornerRadius = 6
        callToActionBtn.clipsToBounds = true
        mrecCardView.addSubview(callToActionBtn)
        
        // Constraints bố cục chuẩn 300x250pt
        NSLayoutConstraint.activate([
            // Khung MREC Card cố định 300x250pt (đặt ở góc trên bên trái mặc định, có thể thay đổi vị trí)
            mrecCardView.widthAnchor.constraint(equalToConstant: 300),
            mrecCardView.heightAnchor.constraint(equalToConstant: 250),
            mrecCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mrecCardView.topAnchor.constraint(equalTo: topAnchor),
            
            // MediaView ở trên cùng (Tỉ lệ 16:9)
            adMediaView.topAnchor.constraint(equalTo: mrecCardView.topAnchor, constant: 8),
            adMediaView.leadingAnchor.constraint(equalTo: mrecCardView.leadingAnchor, constant: 8),
            adMediaView.trailingAnchor.constraint(equalTo: mrecCardView.trailingAnchor, constant: -8),
            adMediaView.heightAnchor.constraint(equalTo: adMediaView.widthAnchor, multiplier: 9.0 / 16.0),
            
            // Cụm Info Bar ở giữa MediaView và CTA
            infoBar.topAnchor.constraint(equalTo: adMediaView.bottomAnchor, constant: 4),
            infoBar.leadingAnchor.constraint(equalTo: mrecCardView.leadingAnchor, constant: 8),
            infoBar.trailingAnchor.constraint(equalTo: mrecCardView.trailingAnchor, constant: -8),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Nút CTA ở dưới cùng
            callToActionBtn.leadingAnchor.constraint(equalTo: mrecCardView.leadingAnchor, constant: 8),
            callToActionBtn.trailingAnchor.constraint(equalTo: mrecCardView.trailingAnchor, constant: -8),
            callToActionBtn.bottomAnchor.constraint(equalTo: mrecCardView.bottomAnchor, constant: -8),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}
