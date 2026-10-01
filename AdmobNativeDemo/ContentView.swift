import SwiftUI
import GoogleMobileAds
import Admob_Native_iOS

struct ContentView: View {
    @State private var controller = AdmobNativeController()
    @State private var statusText = "Sẵn sàng"
    @State private var isAdLoaded = false
    
    // Test Native Ad Unit ID chính thức của Google AdMob iOS
    let testAdUnitId = "ca-app-pub-3940256099942544/3986624511"
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - 1. Tải Quảng Cáo
                Section(header: Text("1. TẢI QUẢNG CÁO")) {
                    Button(action: loadAd) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundColor(.blue)
                            Text("Tải Quảng Cáo Mới (Load Ad)")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    HStack {
                        Text("Trạng thái:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(statusText)
                            .fontWeight(.medium)
                            .foregroundColor(isAdLoaded ? .green : .orange)
                    }
                }
                
                // MARK: - 2. Native Full Screen (Inter, InterOpen, AppOpen, Reward)
                Section(header: Text("2. NATIVE FULL SCREEN")) {
                    Button("🎬 Full Screen Media (Màn Dọc/Ngang)") {
                        showAd(layout: "native_fullscreen_media", countdown: 5.0, initial: 0.5)
                    }
                    Button("🖼️ Full Screen No-Media (Icon Lớn)") {
                        showAd(layout: "native_fullscreen_no_media", countdown: 5.0, initial: 0.0)
                    }
                }

                // MARK: - 3. Native Half-Screen (50% Touch Pass-Through)
                Section(header: Text("3. NATIVE HALF-SCREEN")) {
                    Button("🌓 Half-Screen Media (4:3 Dọc / 16:9 Ngang)") {
                        showAd(layout: "native_halfscreen_media", countdown: 5.0, initial: 0.0)
                    }
                    Button("🌔 Half-Screen No-Media (Icon 120pt)") {
                        showAd(layout: "native_halfscreen_no_media", countdown: 5.0, initial: 0.0)
                    }
                }
                
                // MARK: - 4. Native Banner & MREC
                Section(header: Text("4. NATIVE BANNER & MREC")) {
                    Button("🏷️ Native Banner (60pt Đính Đáy)") {
                        showAd(layout: "native_banner", countdown: 0, initial: 0)
                    }
                    Button("📦 Native MREC Media (300x250)") {
                        showAd(layout: "native_mrec_media", countdown: 0, initial: 0)
                    }
                    Button("📦 Native MREC No-Media (300x250)") {
                        showAd(layout: "native_mrec_no_media", countdown: 0, initial: 0)
                    }
                }
                
                // MARK: - 5. Điều Khiển
                Section(header: Text("5. ĐIỀU KHIỂN")) {
                    Button(role: .destructive, action: destroyAd) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                            Text("Đóng / Hủy Quảng Cáo (Destroy Ad)")
                        }
                    }
                }
            }
            .navigationTitle("AdMob Native iOS Demo")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
    }
    
    private func loadAd() {
        statusText = "Đang tải ad từ Google..."
        isAdLoaded = false
        
        controller.loadAd(adUnitId: testAdUnitId)
        
        // Cập nhật trạng thái sau khi gọi
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            statusText = "Ad đã sẵn sàng để Show!"
            isAdLoaded = true
        }
    }
    
    private func showAd(layout: String, countdown: Float, initial: Float) {
        if countdown > 0 {
            controller.withCountdown(initial: initial, duration: countdown, closeDelay: 1.0)
        }
        controller.showAd(layoutName: layout)
        statusText = "Đang hiển thị: \(layout)"
    }
    
    private func destroyAd() {
        controller.destroyAd()
        statusText = "Ad đã được đóng"
    }
}
