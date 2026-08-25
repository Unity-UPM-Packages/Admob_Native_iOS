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
        // MARK: - 1. Native Interstitial (Full Screen)
        case "native_inter_media":
            return NativeInterMediaLayoutView()
            
        case "native_inter_media_2":
            return NativeInterMedia2LayoutView()
            
        case "native_inter_no_media":
            return NativeInterNoMediaLayoutView()
            
        case "native_inter_no_media_2":
            return NativeInterNoMedia2LayoutView()
            
        // MARK: - 2. Native AppOpen (High CTR)
        case "native_appopen_media":
            return NativeAppOpenMediaLayoutView()
            
        case "native_appopen_no_media":
            return NativeAppOpenNoMediaLayoutView()
            
        // MARK: - 3. Native Reward
        case "native_reward_media":
            return NativeRewardMediaLayoutView()
            
        case "native_reward_media_2":
            return NativeRewardMedia2LayoutView()
            
        case "native_reward_no_media":
            return NativeRewardNoMediaLayoutView()
            
        case "native_reward_no_media_2":
            return NativeRewardNoMedia2LayoutView()
            
        // MARK: - 4. Native Half-Screen
        case "native_halfscreen_media":
            return NativeHalfScreenMediaLayoutView()
            
        case "native_halfscreen_no_media":
            return NativeHalfScreenNoMediaLayoutView()
            
        // MARK: - 5. Native Banner
        case "native_banner":
            return NativeBannerLayoutView(layoutName: name)
            
        // MARK: - 6. Native MREC (300x250)
        case "native_mrec_media", "native_mrec_no_media":
            return NativeMrecLayoutView(layoutName: name)
            
        // MARK: - 7. Native Video
        case "native_video":
            return NativeVideoLayoutView(layoutName: name)
            
        // MARK: - Default Fallback
        default:
            print("[AdmobNativeFactory] Cảnh báo: Không tìm thấy layout chính xác cho '\(layoutName)', dùng fallback 'native_inter_media'")
            return NativeInterMediaLayoutView()
        }
    }
}
