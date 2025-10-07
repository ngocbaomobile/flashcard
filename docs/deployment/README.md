# 🚀 Deployment Guide

Tài liệu hướng dẫn deploy **Ứng Dụng Học Tập** ra các nền tảng khác nhau.

## 📋 Nội Dung

### 📱 [macOS Deployment](./macos.md)
Hướng dẫn chi tiết deploy ứng dụng cho macOS:
- Build process
- Cài đặt vào Applications
- Tạo installer/DMG
- Code signing

### 🔨 [Build Process](./build-process.md)
Quy trình build chi tiết:
- Development build
- Release build
- Debug vs Release
- Build optimization

### 📦 [Distribution](./distribution.md)
Hướng dẫn phân phối ứng dụng:
- Tạo ZIP/DMG files
- App Store preparation
- Notarization process
- Sharing với users

## 🛠️ Prerequisites

### Development Environment
- Flutter SDK (latest stable)
- Dart SDK
- macOS development tools (Xcode)
- Git

### Build Tools
- Xcode Command Line Tools
- macOS SDK
- Code signing certificates (for distribution)

## ⚡ Quick Start

### 1. Build Release Version
```bash
flutter build macos --release
```

### 2. Install to Applications
```bash
cp -R "build/macos/Build/Products/Release/flash_card.app" "/Applications/"
```

### 3. Test Application
```bash
open "/Applications/flash_card.app"
```

## 🎯 Supported Platforms

| Platform | Status | Build Command |
|----------|--------|---------------|
| macOS | ✅ Ready | `flutter build macos --release` |
| iOS | 🔄 Planned | `flutter build ios --release` |
| Android | 🔄 Planned | `flutter build apk --release` |
| Web | 🔄 Planned | `flutter build web --release` |
| Windows | 🔄 Planned | `flutter build windows --release` |
| Linux | 🔄 Planned | `flutter build linux --release` |

## 🔧 Build Commands

### Development Builds
```bash
# Debug build
flutter build macos --debug

# Profile build
flutter build macos --profile
```

### Release Builds
```bash
# Release build
flutter build macos --release

# Release with code signing
flutter build macos --release --codesign
```

### Clean Builds
```bash
# Clean cache and rebuild
flutter clean
flutter pub get
flutter build macos --release
```

## 🚨 Troubleshooting

### Common Issues
1. **Build failures**: Check Flutter doctor
2. **Code signing errors**: Verify certificates
3. **Performance issues**: Optimize build flags

### Support Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [macOS Deployment Guide](https://flutter.dev/docs/deployment/macos)
- [Build Troubleshooting](./troubleshooting.md)

## 📊 Build Statistics

### Current Build Size
- **macOS App**: ~51.6MB
- **Framework**: ~30MB
- **App Bundle**: ~21.6MB

### Performance Metrics
- **Startup time**: < 2 seconds
- **Memory usage**: ~50MB average
- **CPU usage**: < 5% idle

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
name: Build macOS App
on: [push, pull_request]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter build macos --release
```

### Local Automation
```bash
# Build script
#!/bin/bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build macos --release
```

---

**Tài liệu được cập nhật thường xuyên. Kiểm tra version mới nhất trước khi deploy.**
