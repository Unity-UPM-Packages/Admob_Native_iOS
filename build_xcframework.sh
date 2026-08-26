#!/bin/bash
# ==============================================================================
# Script tự động build universal XCFramework cho Admob Native iOS
# Hỗ trợ: iOS Device (arm64) và iOS Simulator (arm64, x86_64)
# ==============================================================================

set -e

SCHEME_NAME="Admob Native iOS"
PROJECT_NAME="Admob Native iOS.xcodeproj"
FRAMEWORK_NAME="Admob_Native_iOS"
OUTPUT_DIR="./build"
XCFRAMEWORK_DIR="${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "🚀 [1/4] Dọn dẹp thư mục build cũ..."
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

echo "📱 [2/4] Đang biên dịch Slice cho iOS Device (arm64)..."
xcodebuild archive \
    -project "${PROJECT_NAME}" \
    -scheme "${SCHEME_NAME}" \
    -destination "generic/platform=iOS" \
    -archivePath "${OUTPUT_DIR}/ios_devices.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "💻 [3/4] Đang biên dịch Slice cho iOS Simulator (arm64, x86_64)..."
xcodebuild archive \
    -project "${PROJECT_NAME}" \
    -scheme "${SCHEME_NAME}" \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "${OUTPUT_DIR}/ios_simulators.xcarchive" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

echo "📦 [4/4] Đang tạo universal ${FRAMEWORK_NAME}.xcframework..."
xcodebuild -create-xcframework \
    -framework "${OUTPUT_DIR}/ios_devices.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -framework "${OUTPUT_DIR}/ios_simulators.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -output "${XCFRAMEWORK_DIR}"

echo ""
echo "=============================================================================="
echo "✅ XUẤT XCFRAMEWORK THÀNH CÔNG!"
echo "📍 Đường dẫn: ${XCFRAMEWORK_DIR}"
echo "👉 File được lưu tại thư mục: ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"
echo "=============================================================================="
