import SwiftUI
import GoogleMobileAds
import Admob_Native_iOS
// Import framework của chúng ta nếu cần, hoặc dùng trực tiếp

struct ContentView: View {
    @State private var controller = AdmobNativeController()
    @State private var statusText = "Ready"
    
    // Test Native Ad Unit ID chính thức của Google AdMob iOS
    let testAdUnitId = "ca-app-pub-3940256099942544/3986624511"
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("1. Tải Quảng Cáo")) {
                    Button("📥 Load Native Ad") {
                        statusText = "Đang tải ad..."
                        controller.loadAd(adUnitId: testAdUnitId)
                    }
                }
                
                Section(header: Text("2. Hiển Thị Các Loại Layout")) {
                    Button("🎬 Show Interstitial (Media)") {
                        controller
                            .withCountdown(initial: 0.5, duration: 5.0, closeDelay: 1.0)
                        controller.showAd(layoutName: "native_inter_media")
                    }
                    
                    Button("🖼️ Show Interstitial (No Media - Meta)") {
                        controller
                            .withCountdown(initial: 0.0, duration: 5.0, closeDelay: 1.0)
                        controller.showAd(layoutName: "native_inter_no_media")
                    }
                    
                    Button("📱 Show AppOpen (High-CTR)") {
                        controller
                            .withCountdown(initial: 0.0, duration: 5.0, closeDelay: 1.0)
                        controller.showAd(layoutName: "native_appopen_media")
                    }
                    
                    Button("🎁 Show Reward (Split Dark V2)") {
                        controller
                            .withCountdown(initial: 0.5, duration: 5.0, closeDelay: 1.0)
                        controller.showAd(layoutName: "native_reward_media_2")
                    }
                    
                    Button("🔲 Show Half-Screen") {
                        controller.showAd(layoutName: "native_halfscreen_media")
                    }
                    
                    Button("🏷️ Show Banner Bottom") {
                        controller.showAd(layoutName: "native_banner")
                    }
                    
                    Button("📦 Show MREC (300x250)") {
                        controller.showAd(layoutName: "native_mrec_media")
                    }
                }
                
                Section(header: Text("3. Điều Khiển")) {
                    Button("❌ Destroy / Hide Ad", role: .destructive) {
                        controller.destroyAd()
                        statusText = "Ad đã được hủy"
                    }
                }
            }
            .navigationTitle("AdMob Native iOS Demo")
        }
        .onAppear {
            // Khởi tạo AdMob SDK
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    }
}
