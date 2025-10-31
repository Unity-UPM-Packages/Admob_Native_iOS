#ifndef AdmobNativeBridge_h
#define AdmobNativeBridge_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// MARK: - Callback Type Definitions

/// Callback with no parameters
typedef void (*VoidCallback)(void);

/// Callback with error message
typedef void (*ErrorCallback)(const char* errorMessage);

/// Callback for paid event
typedef void (*PaidEventCallback)(int precisionType, long long valueMicros, const char* currencyCode);

/// Callback for video mute state
typedef void (*VideoMuteCallback)(bool isMuted);

// MARK: - Controller Management

/// Create a new controller instance
/// @return Handle for use in subsequent function calls
void* AdmobNative_Create(void);

/// Destroy controller instance
/// @param handle Controller handle
void AdmobNative_Destroy(void* handle);

// MARK: - Callback Registration

/// Register all callback functions
void AdmobNative_RegisterCallbacks(
    void* handle,
    VoidCallback onAdLoaded,
    ErrorCallback onAdFailedToLoad,
    VoidCallback onAdShow,
    VoidCallback onAdClosed,
    PaidEventCallback onPaidEvent,
    VoidCallback onAdDidRecordImpression,
    VoidCallback onAdClicked,
    VoidCallback onVideoStart,
    VoidCallback onVideoEnd,
    VideoMuteCallback onVideoMute,
    VoidCallback onVideoPlay,
    VoidCallback onVideoPause,
    VoidCallback onAdShowedFullScreenContent,
    VoidCallback onAdDismissedFullScreenContent
);

// MARK: - Ad Operations

/// Load ad
void AdmobNative_LoadAd(void* handle, const char* adUnitId);

/// Show ad
void AdmobNative_ShowAd(void* handle, const char* layoutName);

/// Destroy current ad
void AdmobNative_DestroyAd(void* handle);

/// Check if ad is available
bool AdmobNative_IsAdAvailable(void* handle);

// MARK: - Configuration (Builder Pattern)

/// Configure countdown timer
void AdmobNative_WithCountdown(void* handle, float initial, float duration, float closeDelay);

/// Configure display position
void AdmobNative_WithPosition(void* handle, int x, int y);

// MARK: - Dimensions

/// Get ad view width
/// @return Width in pixels, -1 if not available
float AdmobNative_GetWidthInPixels(void* handle);

/// Get ad view height
/// @return Height in pixels, -1 if not available
float AdmobNative_GetHeightInPixels(void* handle);

// MARK: - Response Info

/// Get Response ID from ad response
/// @return Response ID string, or NULL if not available
const char* AdmobNative_GetResponseId(void* handle);

/// Get Mediation Adapter Class Name
/// @return Adapter class name, or NULL if not available
const char* AdmobNative_GetMediationAdapterClassName(void* handle);

#ifdef __cplusplus
}
#endif

#endif /* AdmobNativeBridge_h */
