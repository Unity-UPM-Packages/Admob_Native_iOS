#!/bin/sh

# ======== CẤU HÌNH ========
# Tên scheme của framework (thường trùng tên target)
SCHEME_NAME="admob_native_unity"

# Tên file .xcodeproj của bạn
PROJECT_FILE="Admob_Native_iOS.xcodeproj"

# Tên framework cuối cùng (thường trùng tên scheme)
FRAMEWORK_NAME="admob_native_unity"
# ==========================


# --- Đường dẫn và thư mục ---
BUILD_DIR="./build"
DEVICE_ARCHIVE_PATH="${BUILD_DIR}/device.xcarchive"
SIMULATOR_ARCHIVE_PATH="${BUILD_DIR}/simulator.xcarchive"
OUTPUT_XCFRAMEWORK_PATH="${BUILD_DIR}/${FRAMEWORK_NAME}.xcframework"


# --- Bước 0: Dọn dẹp ---
echo "🧼 Dọn dẹp thư mục build cũ..."
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"


# --- Bước 1: Build cho iOS Devices (arm64) ---
echo "📱 Building cho iOS Device (thiết bị thật)..."
xcodebuild archive \
  -scheme "$SCHEME_NAME" \
  -project "$PROJECT_FILE" \
  -destination "generic/platform=iOS" \
  -archivePath "$DEVICE_ARCHIVE_PATH" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

# Kiểm tra lỗi
if [ $? -ne 0 ]; then
    echo "❌ Build cho Device thất bại"
    exit 1
fi


# --- Bước 2: Build cho iOS Simulator (arm64 + x86_64) ---
echo "🖥️ Building cho iOS Simulator (máy ảo)..."
xcodebuild archive \
  -scheme "$SCHEME_NAME" \
  -project "$PROJECT_FILE" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$SIMULATOR_ARCHIVE_PATH" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

# Kiểm tra lỗi
if [ $? -ne 0 ]; then
    echo "❌ Build cho Simulator thất bại"
    exit 1
fi


# --- Bước 3: Tạo XCFramework ---
echo "📦 Gộp 2 bản build thành XCFramework..."
xcodebuild -create-xcframework \
  -framework "$DEVICE_ARCHIVE_PATH/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "$SIMULATOR_ARCHIVE_PATH/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "$OUTPUT_XCFRAMEWORK_PATH"


# --- Hoàn tất ---
echo "✅ Xong! File framework được tạo tại: $OUTPUT_XCFRAMEWORK_PATH"

# Mở thư mục build trong Finder
open "$BUILD_DIR"