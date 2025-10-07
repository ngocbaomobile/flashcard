# 📚 Tài Liệu Source Code - Ứng Dụng Học Tập

## 🏗️ Kiến Trúc Tổng Quan

Ứng dụng được xây dựng theo **Clean Architecture** với 3 layers chính:

```
┌─────────────────────────────────────┐
│           Presentation              │
│  (UI, Bloc, Pages, Widgets)        │
├─────────────────────────────────────┤
│             Domain                  │
│  (Entities, UseCases, Repositories)│
├─────────────────────────────────────┤
│              Data                   │
│  (Models, DataSources, Repos Impl) │
└─────────────────────────────────────┘
```

## 📁 Cấu Trúc Chi Tiết

### 🎯 Domain Layer
**Vị trí**: `lib/domain/`

#### Entities
- **`flash_card_entity.dart`**: Định nghĩa FlashCard entity
- **`random_text_entity.dart`**: Định nghĩa RandomText entity

#### Repositories (Interfaces)
- **`flash_card_repository.dart`**: Interface cho FlashCard data operations
- **`random_text_repository.dart`**: Interface cho RandomText operations

#### Use Cases
- **`get_all_flash_cards.dart`**: Lấy tất cả flash cards
- **`create_flash_card.dart`**: Tạo flash card mới
- **`delete_flash_card.dart`**: Xóa flash card
- **`parse_text_to_items.dart`**: Parse text thành danh sách items
- **`select_random_item.dart`**: Chọn item ngẫu nhiên

### 🗄️ Data Layer
**Vị trí**: `lib/data/`

#### Models
- **`flash_card_model.dart`**: Model cho FlashCard với JSON serialization
- **`flash_card_model.g.dart`**: Generated code cho JSON serialization

#### Data Sources
- **`flash_card_local_datasource.dart`**: Interface cho local data source
- **`flash_card_local_datasource_impl.dart`**: Implementation sử dụng SQLite

#### Repository Implementations
- **`flash_card_repository_impl.dart`**: Implementation của FlashCard repository
- **`random_text_repository_impl.dart`**: Implementation của RandomText repository

### 🎨 Presentation Layer
**Vị trí**: `lib/presentation/`

#### Bloc (State Management)
- **`flash_card_bloc.dart`**: Quản lý state cho FlashCard feature
- **`flash_card_event.dart`**: Định nghĩa các events
- **`flash_card_state.dart`**: Định nghĩa các states
- **`random_text_bloc.dart`**: Quản lý state cho RandomText feature
- **`random_text_event.dart`**: Định nghĩa các events
- **`random_text_state.dart`**: Định nghĩa các states

#### Pages
- **`main_menu_page.dart`**: Trang menu chính
- **`flash_card_page.dart`**: Trang quản lý flash cards
- **`add_flash_card_page.dart`**: Trang thêm flash card mới
- **`random_text_page.dart`**: Trang random text selector

#### Widgets
- **`flash_card_grid.dart`**: Grid hiển thị flash cards
- Các widgets khác cho UI components

### 🔧 Core Layer
**Vị trí**: `lib/core/`

#### Dependency Injection
- **`injection.dart`**: Cấu hình GetIt cho dependency injection

## 🔄 Luồng Dữ Liệu (Data Flow)

### Flash Card Feature
```
UI → Event → Bloc → UseCase → Repository → DataSource → SQLite
                ↓
UI ← State ← Bloc ← UseCase ← Repository ← DataSource ← SQLite
```

### Random Text Feature
```
UI → Event → Bloc → UseCase → Repository (In-memory processing)
                ↓
UI ← State ← Bloc ← UseCase ← Repository
```

## 🎯 Chi Tiết Các Components

### 1. Flash Card Bloc

#### Events
```dart
class LoadFlashCards extends FlashCardEvent
class CreateFlashCard extends FlashCardEvent
class DeleteFlashCard extends FlashCardEvent
```

#### States
```dart
class FlashCardInitial extends FlashCardState
class FlashCardLoading extends FlashCardState
class FlashCardLoaded extends FlashCardState
class FlashCardError extends FlashCardState
```

#### Business Logic
- Load tất cả flash cards từ database
- Tạo flash card mới và lưu vào database
- Xóa flash card và cập nhật database
- Handle error states

### 2. Random Text Bloc

#### Events
```dart
class ParseTextEvent extends RandomTextEvent
class StartShuffleEvent extends RandomTextEvent
class StopShuffleEvent extends RandomTextEvent
class UpdateResultEvent extends RandomTextEvent
```

#### States
```dart
class RandomTextInitial extends RandomTextState
class RandomTextLoading extends RandomTextState
class RandomTextShuffling extends RandomTextState
class RandomTextResult extends RandomTextState
class RandomTextError extends RandomTextState
```

#### Business Logic
- Parse text input thành danh sách items
- Tạo hiệu ứng shuffle animation
- Chọn item ngẫu nhiên cuối cùng
- Quản lý timer cho animation

### 3. Database Schema

#### Flash Card Table
```sql
CREATE TABLE flash_cards (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  front_text TEXT NOT NULL,
  back_text TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

### 4. Dependency Injection Setup

```dart
// Bloc registration
sl.registerFactory(() => FlashCardBloc(...));
sl.registerFactory(() => RandomTextBloc(...));

// Use case registration
sl.registerLazySingleton(() => GetAllFlashCardsUsecase(sl()));
sl.registerLazySingleton(() => CreateFlashCardUsecase(sl()));
sl.registerLazySingleton(() => DeleteFlashCardUsecase(sl()));
sl.registerLazySingleton(() => ParseTextToItemsUsecase(sl()));
sl.registerLazySingleton(() => SelectRandomItemUsecase(sl()));

// Repository registration
sl.registerLazySingleton<FlashCardRepository>(() => FlashCardRepositoryImpl(...));
sl.registerLazySingleton<RandomTextRepository>(() => RandomTextRepositoryImpl());

// Data source registration
sl.registerLazySingleton<FlashCardLocalDataSource>(() => FlashCardLocalDataSourceImpl());
```

## 🎨 UI/UX Design Patterns

### 1. Material Design 3
- Sử dụng Material 3 design system
- Color scheme với seed color
- Typography theo Material guidelines

### 2. Responsive Design
- Grid layout cho flash cards
- Single column cho mobile
- Adaptive spacing và sizing

### 3. Animation
- AnimatedSwitcher cho text transitions
- ScaleTransition và FadeTransition
- Smooth navigation transitions

## 🔒 Error Handling

### 1. Bloc Error Handling
```dart
try {
  // Business logic
} catch (e) {
  emit(ErrorState('Error message: $e'));
}
```

### 2. UI Error Display
```dart
BlocConsumer<BlocType, StateType>(
  listener: (context, state) {
    if (state is ErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  // ...
)
```

### 3. Database Error Handling
```dart
try {
  await database.insert('flash_cards', data);
} catch (e) {
  throw DatabaseException('Failed to insert flash card: $e');
}
```

## 🧪 Testing Strategy

### 1. Unit Tests
- Test cho Use Cases
- Test cho Repository implementations
- Test cho Bloc logic

### 2. Widget Tests
- Test UI components
- Test user interactions
- Test state changes

### 3. Integration Tests
- Test complete user flows
- Test database operations
- Test navigation

## 🚀 Performance Considerations

### 1. Database Optimization
- Sử dụng prepared statements
- Lazy loading cho large datasets
- Proper indexing

### 2. Memory Management
- Dispose controllers properly
- Cancel timers in bloc close()
- Clean up resources

### 3. UI Performance
- Efficient list rendering
- Image caching
- Smooth animations

## 📱 Platform-Specific Code

### macOS
- Native macOS app structure
- macOS-specific styling
- Platform channels nếu cần

### Future Platforms
- iOS: Touch gestures, iOS design
- Android: Material Design, Android navigation
- Web: Responsive design, web-specific features

## 🔧 Development Tools

### 1. Code Generation
```bash
# Generate JSON serialization
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### 2. Code Analysis
```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

### 3. Dependencies Management
```bash
# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

## 📋 Coding Standards

### 1. Naming Conventions
- Classes: PascalCase (`FlashCardBloc`)
- Variables: camelCase (`flashCardList`)
- Files: snake_case (`flash_card_bloc.dart`)

### 2. File Organization
- One class per file
- Grouped by feature
- Clear import structure

### 3. Documentation
- Class documentation
- Method documentation
- Inline comments for complex logic

## 🔄 Future Enhancements

### 1. Features
- Quiz mode
- Statistics tracking
- Import/Export functionality
- Cloud sync

### 2. Architecture
- Offline-first approach
- Repository caching
- Background processing

### 3. UI/UX
- Dark mode support
- Custom themes
- Accessibility improvements

---

## 📞 Support & Maintenance

### Code Review Checklist
- [ ] Clean Architecture principles
- [ ] Proper error handling
- [ ] Performance considerations
- [ ] UI/UX consistency
- [ ] Test coverage

### Maintenance Tasks
- Regular dependency updates
- Performance monitoring
- User feedback integration
- Security updates

---

**Tài liệu này sẽ được cập nhật khi có thay đổi trong codebase.**
