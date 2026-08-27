//
//  NativeMrecNoMediaLayoutView.swift
//  Admob Native iOS
//
//  Layout Native MREC No-Media (300x250pt), nền #0E2139, CTA màu #C9FF23.
//  Từ dưới lên: CTA -> Icon ứng dụng căn giữa -> Cụm Text ([Ad] + Headline + Body).
//  Ánh xạ 1:1 chuẩn xác với Android: res/layout/native_mrec_no_media.xml.
//

import UIKit
import GoogleMobileAds

public final class NativeMrecNoMediaLayoutView: BaseNativeAdLayoutView {
    
    // Card MREC kích thước cố định 300x250pt
    private let mrecCardView = UIView()
    
    // Icon lớn căn giữa
    public let largeIconImgView = UIImageView()
    
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
        
        // 2. Nhãn Ad màu vàng chữ nâu
        adBadgeLbl.translatesAutoresizingMaskIntoConstraints = false
        adBadgeLbl.backgroundColor = .gntAdBadgeYellow
        adBadgeLbl.textColor = .gntAdBadgeTextBrown
        adBadgeLbl.font = UIFont.boldSystemFont(ofSize: 10)
        adBadgeLbl.layer.cornerRadius = 3
        adBadgeLbl.clipsToBounds = true
        adBadgeLbl.textAlignment = .center
        
        // 3. Headline (chữ trắng in đậm)
        headlineLbl.translatesAutoresizingMaskIntoConstraints = false
        headlineLbl.textColor = .white
        headlineLbl.font = UIFont.boldSystemFont(ofSize: 14)
        headlineLbl.numberOfLines = 1
        headlineLbl.lineBreakMode = .byTruncatingTail
        headlineLbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // 4. Advertiser (chữ xám #B6BCC3)
        advertiserLbl.translatesAutoresizingMaskIntoConstraints = false
        advertiserLbl.textColor = UIColor(hex: "#B6BCC3")
        advertiserLbl.font = UIFont.systemFont(ofSize: 12)
        advertiserLbl.numberOfLines = 1
        advertiserLbl.lineBreakMode = .byTruncatingTail
        
        // 5. Cấu hình Cụm Info Bar ở phía trên cùng
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
        infoBar.addArrangedSubview(advertiserLbl)
        mrecCardView.addSubview(infoBar)
        
        // 6. Icon lớn căn giữa (100x100pt, bo góc 16pt)
        largeIconImgView.translatesAutoresizingMaskIntoConstraints = false
        largeIconImgView.contentMode = .scaleAspectFit
        largeIconImgView.layer.cornerRadius = 16
        largeIconImgView.clipsToBounds = true
        largeIconImgView.backgroundColor = .clear
        mrecCardView.addSubview(largeIconImgView)
        
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
            
            // Cụm Info Bar ở trên cùng
            infoBar.topAnchor.constraint(equalTo: mrecCardView.topAnchor, constant: 10),
            infoBar.leadingAnchor.constraint(equalTo: mrecCardView.leadingAnchor, constant: 12),
            infoBar.trailingAnchor.constraint(equalTo: mrecCardView.trailingAnchor, constant: -12),
            
            adBadgeLbl.widthAnchor.constraint(equalToConstant: 24),
            adBadgeLbl.heightAnchor.constraint(equalToConstant: 16),
            
            // Icon lớn căn giữa ở khoảng trống trung tâm
            largeIconImgView.centerXAnchor.constraint(equalTo: mrecCardView.centerXAnchor),
            largeIconImgView.centerYAnchor.constraint(equalTo: mrecCardView.centerYAnchor, constant: 10),
            largeIconImgView.widthAnchor.constraint(equalToConstant: 100),
            largeIconImgView.heightAnchor.constraint(equalToConstant: 100),
            
            // Nút CTA ở dưới cùng
            callToActionBtn.leadingAnchor.constraint(equalTo: mrecCardView.leadingAnchor, constant: 12),
            callToActionBtn.trailingAnchor.constraint(equalTo: mrecCardView.trailingAnchor, constant: -12),
            callToActionBtn.bottomAnchor.constraint(equalTo: mrecCardView.bottomAnchor, constant: -10),
            callToActionBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
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
