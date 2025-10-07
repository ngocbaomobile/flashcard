# 🍎 macOS Deployment Guide

Hướng dẫn chi tiết deploy **Ứng Dụng Học Tập** cho macOS.

## 📋 Yêu Cầu

### System Requirements
- macOS 10.14 (Mojave) trở lên
- Xcode 12.0 trở lên
- Flutter SDK latest stable
- macOS development tools

### Prerequisites Check
```bash
# Kiểm tra Flutter
flutter doctor

# Kiểm tra Xcode
xcode-select --print-path

# Kiểm tra macOS version
sw_vers
```

## 🛠️ Build Process

### 1. Preparation
```bash
# Clone repository (nếu cần)
git clone <repository-url>
cd flashcard

# Install dependencies
flutter pub get

# Clean previous builds
flutter clean
```

### 2. Build Release Version
```bash
# Build cho macOS
flutter build macos --release

# Kiểm tra file output
ls -la build/macos/Build/Products/Release/
```

### 3. Verify Build
```bash
# Test app locally
open build/macos/Build/Products/Release/flash_card.app

# Check app size
du -sh build/macos/Build/Products/Release/flash_card.app
```

## 📦 Installation

### Method 1: Manual Copy
```bash
# Copy to Applications folder
cp -R "build/macos/Build/Products/Release/flash_card.app" "/Applications/"

# Verify installation
ls -la "/Applications/" | grep flash_card

# Launch app
open "/Applications/flash_card.app"
```

### Method 2: Drag & Drop
1. Mở Finder
2. Navigate đến `build/macos/Build/Products/Release/`
3. Drag `flash_card.app` vào `/Applications/`
4. Confirm copy operation

## 🎯 Distribution

### Create ZIP Archive
```bash
# Navigate to build directory
cd build/macos/Build/Products/Release/

# Create ZIP file
zip -r flash_card_macos.zip flash_card.app

# Verify ZIP
unzip -l flash_card_macos.zip
```

### Create DMG Installer (Advanced)
```bash
# Install create-dmg (nếu chưa có)
brew install create-dmg

# Create DMG
create-dmg \
  --volname "Ứng Dụng Học Tập" \
  --window-pos 200 120 \
  --window-size 600 300 \
  --icon-size 100 \
  --icon "flash_card.app" 175 120 \
  --hide-extension "flash_card.app" \
  --app-drop-link 425 120 \
  "flash_card.dmg" \
  "build/macos/Build/Products/Release/"
```

## 🔐 Code Signing (Optional)

### Setup Certificates
```bash
# List available certificates
security find-identity -v -p codesigning

# Build with code signing
flutter build macos --release --codesign
```

### Notarization (App Store)
```bash
# Create notarization request
xcrun altool --notarize-app \
  --primary-bundle-id "com.example.flashcard" \
  --username "your-apple-id" \
  --password "app-specific-password" \
  --file "flash_card.zip"
```

## 🧪 Testing

### Pre-Release Testing
```bash
# Test on different macOS versions
# Test with different screen resolutions
# Test accessibility features
# Test performance
```

### Automated Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter drive --target=test_driver/app.dart

# Run widget tests
flutter test test/widget_test.dart
```

## 📊 Build Optimization

### Size Optimization
```bash
# Analyze app size
flutter build macos --analyze-size

# Remove unused code
flutter build macos --tree-shake-icons

# Optimize for size
flutter build macos --release --obfuscate --split-debug-info=build/debug-info
```

### Performance Optimization
```bash
# Build with profile mode
flutter build macos --profile

# Enable performance mode
flutter build macos --release --enable-impeller
```

## 🚨 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build macos --release
```

#### Code Signing Issues
```bash
# Check certificates
security find-identity -v -p codesigning

# Reset keychain
security delete-identity -c "Developer ID Application"
```

#### App Launch Issues
```bash
# Check console logs
log show --predicate 'process == "flash_card"' --last 1h

# Check app permissions
spctl -a -v "/Applications/flash_card.app"
```

### Debug Commands
```bash
# Enable debug logging
flutter build macos --debug

# Verbose build output
flutter build macos --verbose

# Check dependencies
flutter pub deps
```

## 📱 App Store Submission (Future)

### Preparation
1. Create Apple Developer account
2. Setup App Store Connect
3. Prepare app metadata
4. Create screenshots
5. Write app description

### Submission Process
1. Archive app in Xcode
2. Upload to App Store Connect
3. Submit for review
4. Handle review feedback

## 🔄 Updates & Maintenance

### Version Management
```bash
# Update version in pubspec.yaml
version: 1.0.1+1

# Build new version
flutter build macos --release
```

### Hotfix Process
1. Fix critical issues
2. Increment patch version
3. Build and test
4. Distribute update

## 📈 Monitoring

### Analytics Setup
- Track app usage
- Monitor crashes
- Performance metrics
- User feedback

### Update Strategy
- Automatic updates
- Manual updates
- Rollback capability
- A/B testing

---

## 📞 Support

Nếu gặp vấn đề trong quá trình deploy:

1. Kiểm tra [Troubleshooting](./troubleshooting.md)
2. Xem [Build Process](./build-process.md)
3. Tham khảo [Flutter macOS Guide](https://flutter.dev/docs/deployment/macos)

---

**Cập nhật lần cuối**: Tháng 12, 2024
