//
//  NativeLayoutFactory.swift
//  Admob Native iOS
//
//  Factory ánh xạ chuỗi layoutName truyền từ Unity C# sang View UIKit tương ứng.
//

import UIKit

public final class NativeLayoutFactory {
    public static func createLayout(layoutName: String) -> BaseNativeAdLayoutView {
        let name = layoutName.lowercased()
        
        if name.contains("appopen") {
            return NativeAppOpenLayoutView(layoutName: name)
        } else if name.contains("reward") {
            return NativeRewardLayoutView(layoutName: name)
        } else if name.contains("halfscreen") {
            return NativeHalfScreenLayoutView(layoutName: name)
        } else if name.contains("banner") {
            return NativeBannerLayoutView(layoutName: name)
        } else if name.contains("mrec") {
            return NativeMrecLayoutView(layoutName: name)
        } else if name.contains("video") {
            return NativeVideoLayoutView(layoutName: name)
        } else {
            // Mặc định là Interstitial (native_inter_media, native_inter_no_media, v.v.)
            return NativeInterLayoutView(layoutName: name)
        }
    }
}
