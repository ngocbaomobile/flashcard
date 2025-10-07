# 📚 Ứng Dụng Học Tập

Ứng dụng Flutter được xây dựng theo Clean Architecture với các tính năng học tập đa dạng.

## 🚀 Tính Năng

- **Flash Cards**: Quản lý và học từ vựng với thẻ ghi nhớ
- **Random Text**: Chọn ngẫu nhiên từ danh sách với hiệu ứng animation
- **Menu Navigation**: Giao diện thân thiện với navigation dễ dàng

## 🏗️ Kiến Trúc

- **Clean Architecture**: Domain, Data, Presentation layers
- **State Management**: Bloc pattern
- **Dependency Injection**: GetIt
- **Local Storage**: SQLite

## 📱 Nền Tảng Hỗ Trợ

- ✅ macOS (Đã deploy)
- 🔄 iOS (Planned)
- 🔄 Android (Planned)
- 🔄 Web (Planned)

## 🛠️ Cài Đặt & Chạy

### Yêu Cầu
- Flutter SDK
- Dart SDK
- macOS development tools

### Chạy Development
```bash
flutter pub get
flutter run -d macos
```

### Build Release
```bash
flutter build macos --release
```

## 📖 Tài Liệu

- [📚 Tài Liệu Đầy Đủ](docs/) - Bộ tài liệu hoàn chỉnh
  - [🚀 Deployment](docs/deployment/) - Hướng dẫn build và deploy
  - [🏗️ Architecture](docs/architecture/) - Kiến trúc và thiết kế hệ thống
  - [🛠️ Development](docs/development/) - Hướng dẫn development
  - [🔌 API](docs/api/) - Tài liệu API và interfaces

## 🎯 Tính Năng Chính

### Flash Cards
- Tạo, chỉnh sửa, xóa flash cards
- Giao diện grid hiện đại
- Lưu trữ local với SQLite

### Random Text Selector
- Nhập danh sách tùy chỉnh
- Hiệu ứng animation xáo trộn
- Kết quả hiển thị với animation

### Menu System
- Navigation trực quan
- Thiết kế Material Design 3
- Responsive layout

## 🔧 Development

### Cấu Trúc Project
```
lib/
├── core/di/          # Dependency Injection
├── domain/           # Business Logic
├── data/             # Data Layer
└── presentation/     # UI Layer
```

### Commands Hữu Ích
```bash
# Phân tích code
flutter analyze

# Format code
dart format .

# Test
flutter test

# Clean build
flutter clean && flutter pub get
```

## 📄 License

Dự án này được phát triển cho mục đích học tập và cá nhân.

---

**Ứng dụng sẵn sàng sử dụng trên macOS! 🎉**