# 🛠️ Development Guide

Hướng dẫn development cho **Ứng Dụng Học Tập** - từ setup môi trường đến best practices.

## 📋 Nội Dung

### ⚙️ [Setup Environment](./setup.md)
Hướng dẫn cài đặt môi trường development:
- Flutter SDK installation
- IDE setup
- Dependencies installation
- Configuration

### 📝 [Coding Standards](./coding-standards.md)
Chuẩn coding và best practices:
- Naming conventions
- Code organization
- Documentation standards
- Code review guidelines

### 🧪 [Testing Guide](./testing.md)
Hướng dẫn testing toàn diện:
- Unit testing
- Widget testing
- Integration testing
- Test automation

### 🔧 [Troubleshooting](./troubleshooting.md)
Xử lý lỗi thường gặp:
- Build errors
- Runtime errors
- Performance issues
- Debug techniques

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone <repository-url>
cd flashcard
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Application
```bash
flutter run -d macos
```

### 4. Start Development
```bash
# Enable hot reload
flutter run -d macos --hot

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 🛠️ Development Tools

### Required Tools
- **Flutter SDK**: Latest stable version
- **Dart SDK**: Bundled with Flutter
- **IDE**: VS Code, Android Studio, hoặc IntelliJ
- **Git**: Version control
- **Xcode**: For macOS development

### Recommended Extensions (VS Code)
- Flutter
- Dart
- GitLens
- Bracket Pair Colorizer
- Error Lens
- Todo Tree

### Recommended Plugins (Android Studio)
- Flutter
- Dart
- Git Integration
- Database Navigator

## 📁 Project Structure

```
flashcard/
├── lib/
│   ├── core/              # Core utilities
│   │   └── di/           # Dependency injection
│   ├── data/             # Data layer
│   │   ├── datasources/  # Data sources
│   │   ├── models/       # Data models
│   │   └── repositories/ # Repository implementations
│   ├── domain/           # Domain layer
│   │   ├── entities/     # Business entities
│   │   ├── repositories/ # Repository interfaces
│   │   └── usecases/     # Use cases
│   ├── presentation/     # Presentation layer
│   │   ├── bloc/         # State management
│   │   ├── pages/        # UI pages
│   │   └── widgets/      # Reusable widgets
│   └── main.dart         # App entry point
├── test/                 # Test files
├── docs/                 # Documentation
└── pubspec.yaml          # Dependencies
```

## 🔄 Development Workflow

### 1. Feature Development
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes
# Write tests
# Update documentation

# Commit changes
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/new-feature
```

### 2. Code Review Process
1. Create Pull Request
2. Request review from team members
3. Address feedback
4. Merge to main branch

### 3. Release Process
1. Update version in `pubspec.yaml`
2. Update changelog
3. Create release tag
4. Build and deploy

## 🧪 Testing Strategy

### Test Types
- **Unit Tests**: Test individual functions/classes
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows

### Test Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Test Coverage
- Target: >80% code coverage
- Focus on business logic
- Test error scenarios
- Mock external dependencies

## 📊 Code Quality

### Static Analysis
```bash
# Run analyzer
flutter analyze

# Fix auto-fixable issues
dart fix --apply

# Format code
dart format .
```

### Code Metrics
- Cyclomatic complexity
- Code duplication
- Test coverage
- Performance metrics

## 🔧 Development Commands

### Daily Commands
```bash
# Check Flutter status
flutter doctor

# Get dependencies
flutter pub get

# Run app in debug mode
flutter run -d macos

# Run app in release mode
flutter run -d macos --release

# Hot reload (when running)
r  # Press 'r' in terminal
```

### Build Commands
```bash
# Debug build
flutter build macos --debug

# Release build
flutter build macos --release

# Profile build
flutter build macos --profile

# Clean build
flutter clean && flutter pub get
```

### Utility Commands
```bash
# Check dependencies
flutter pub deps

# Update dependencies
flutter pub upgrade

# Outdated packages
flutter pub outdated

# Generate code
flutter packages pub run build_runner build
```

## 🐛 Debugging

### Debug Tools
- **Flutter Inspector**: Widget tree inspection
- **Dart DevTools**: Performance profiling
- **VS Code Debugger**: Breakpoint debugging
- **Console Logging**: Print statements

### Debug Commands
```bash
# Run with debug info
flutter run -d macos --debug

# Verbose output
flutter run -d macos --verbose

# Enable performance overlay
flutter run -d macos --enable-performance-overlay
```

## 📱 Platform-Specific Development

### macOS Development
```bash
# Run on macOS
flutter run -d macos

# Build for macOS
flutter build macos

# Open Xcode project
open macos/Runner.xcworkspace
```

### Future Platforms
- iOS development setup
- Android development setup
- Web development setup

## 🔄 CI/CD Integration

### GitHub Actions
```yaml
name: CI/CD Pipeline
on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter test
      - run: flutter analyze
```

### Local Automation
```bash
# Pre-commit hook
#!/bin/bash
flutter analyze
flutter test
dart format --set-exit-if-changed .
```

## 📚 Learning Resources

### Flutter Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Samples](https://flutter.dev/docs/cookbook)

### Architecture Resources
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Bloc Pattern](https://bloclibrary.dev/)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

## 🤝 Contributing

### Contribution Guidelines
1. Follow coding standards
2. Write tests for new features
3. Update documentation
4. Create descriptive PRs

### Code Review Checklist
- [ ] Code follows standards
- [ ] Tests are included
- [ ] Documentation is updated
- [ ] Performance is considered
- [ ] Security is addressed

---

## 📞 Support

Nếu gặp vấn đề trong development:
1. Kiểm tra [Troubleshooting](./troubleshooting.md)
2. Xem [Setup Guide](./setup.md)
3. Tham khảo [Coding Standards](./coding-standards.md)

---

**Happy coding! 🎉**
