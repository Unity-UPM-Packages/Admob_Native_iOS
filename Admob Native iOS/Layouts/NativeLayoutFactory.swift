//
//  NativeLayoutFactory.swift
//  Admob Native iOS
//
//  Factory ánh xạ chuỗi layoutName truyền từ Unity C# sang View UIKit tương ứng.
//  Khớp chính xác 100% từng chuỗi layoutName từ Android.
//

import UIKit

public final class NativeLayoutFactory {
    
    public static func createLayout(layoutName: String) -> BaseNativeAdLayoutView {
        let name = layoutName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch name {
        // MARK: - 1. Native Full Screen (dùng chung cho Inter, InterOpen, AppOpen, Reward)
        case "native_fullscreen_media":
            return NativeFullScreenMediaLayoutView()

        case "native_fullscreen_no_media":
            return NativeFullScreenNoMediaLayoutView()

        // MARK: - 2. Native Half-Screen
        case "native_halfscreen_media":
            return NativeHalfScreenMediaLayoutView()
            
        case "native_halfscreen_no_media":
            return NativeHalfScreenNoMediaLayoutView()
            
        // MARK: - 3. Native Banner
        case "native_banner":
            return NativeBannerLayoutView()
            
        // MARK: - 4. Native MREC (300x250)
        case "native_mrec_media":
            return NativeMrecMediaLayoutView()
            
        case "native_mrec_no_media":
            return NativeMrecNoMediaLayoutView()
            
        // MARK: - 5. Native Video
        case "native_video":
            return NativeVideoLayoutView(layoutName: name)
            
        // MARK: - Default Fallback
        default:
            print("[AdmobNativeFactory] Cảnh báo: Không tìm thấy layout chính xác cho '\(layoutName)', dùng fallback 'native_fullscreen_media'")
            return NativeFullScreenMediaLayoutView()
        }
    }
}
