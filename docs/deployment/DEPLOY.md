# 🚀 Hướng Dẫn Deploy Ứng Dụng Học Tập

## 📋 Tổng Quan

Tài liệu này hướng dẫn cách build và deploy ứng dụng Flutter **Ứng Dụng Học Tập** ra các nền tảng khác nhau.

## 🛠️ Yêu Cầu Hệ Thống

### Prerequisites
- Flutter SDK (phiên bản mới nhất)
- Dart SDK
- macOS development tools (Xcode)
- Git

### Kiểm Tra Môi Trường
```bash
flutter doctor
```

## 📱 Build cho macOS

### 1. Build Release Version
```bash
flutter build macos --release
```

### 2. Kiểm Tra File Build
```bash
ls -la build/macos/Build/Products/Release/
```

File app sẽ được tạo tại: `build/macos/Build/Products/Release/flash_card.app`

### 3. Cài Đặt vào Applications
```bash
# Copy app vào thư mục Applications
cp -R "build/macos/Build/Products/Release/flash_card.app" "/Applications/"

# Kiểm tra đã cài đặt thành công
ls -la "/Applications/" | grep flash_card

# Mở ứng dụng
open "/Applications/flash_card.app"
```

### 4. Chia Sẻ App
Để chia sẻ app cho người khác:
```bash
# Tạo ZIP file
cd build/macos/Build/Products/Release/
zip -r flash_card_macos.zip flash_card.app

# Hoặc tạo DMG (tùy chọn)
# Cần cài đặt create-dmg: brew install create-dmg
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

## 🎯 Tính Năng Ứng Dụng

### Menu Chính
- **Flash Cards**: Quản lý thẻ học từ vựng
- **Random Text**: Chọn ngẫu nhiên từ danh sách
- **Tính năng tương lai**: Sẵn sàng mở rộng

### Kiến Trúc
- **Clean Architecture**: Domain, Data, Presentation layers
- **State Management**: Bloc pattern
- **Dependency Injection**: GetIt
- **Local Storage**: SQLite với sqflite

## 🔧 Development Commands

### Chạy Ứng Dụng trong Development
```bash
# Chạy trên macOS
flutter run -d macos

# Chạy với hot reload
flutter run -d macos --hot

# Chạy với debug info
flutter run -d macos --verbose
```

### Testing
```bash
# Chạy unit tests
flutter test

# Chạy integration tests
flutter drive --target=test_driver/app.dart
```

### Code Quality
```bash
# Phân tích code
flutter analyze

# Format code
dart format .

# Kiểm tra dependencies
flutter pub deps
```

## 📦 Build cho Các Nền Tảng Khác

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
# hoặc
flutter build appbundle --release
```

### Web
```bash
flutter build web --release
```

### Linux
```bash
flutter build linux --release
```

### Windows
```bash
flutter build windows --release
```

## 🚨 Troubleshooting

### Lỗi Thường Gặp

#### 1. Flutter Doctor Issues
```bash
# Cài đặt các tools cần thiết
flutter doctor --android-licenses
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

#### 2. Build Errors
```bash
# Clean build cache
flutter clean
flutter pub get

# Rebuild
flutter build macos --release
```

#### 3. Dependencies Issues
```bash
# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

#### 4. Code Signing (macOS)
```bash
# Kiểm tra certificates
security find-identity -v -p codesigning

# Build với code signing
flutter build macos --release --codesign
```

## 📁 Cấu Trúc Project

```
flashcard/
├── lib/
│   ├── core/
│   │   └── di/
│   │       └── injection.dart
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── presentation/
│   │   ├── bloc/
│   │   ├── pages/
│   │   └── widgets/
│   └── main.dart
├── macos/
├── ios/
├── android/
├── web/
├── windows/
├── linux/
└── build/
```

## 🔄 CI/CD Pipeline (Tùy Chọn)

### GitHub Actions Example
```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-macos:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
    - run: flutter build macos --release
    - uses: actions/upload-artifact@v2
      with:
        name: macos-app
        path: build/macos/Build/Products/Release/flash_card.app
```

## 📝 Release Notes

### Version 1.0.0
- ✅ Menu chính với navigation
- ✅ Flash Cards feature
- ✅ Random Text feature với animation
- ✅ Clean Architecture implementation
- ✅ macOS app deployment

### Roadmap
- 🔄 iOS version
- 🔄 Android version
- 🔄 Web version
- 🔄 Thêm tính năng Quiz
- 🔄 Thêm tính năng Statistics

## 📞 Support

Nếu gặp vấn đề trong quá trình build hoặc deploy:

1. Kiểm tra `flutter doctor`
2. Clean và rebuild project
3. Kiểm tra dependencies
4. Tham khảo Flutter documentation

## 📄 License

Dự án này được phát triển cho mục đích học tập và cá nhân.

---

**Chúc bạn deploy thành công! 🎉**
