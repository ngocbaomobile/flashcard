# 🏗️ Architecture Documentation

Tài liệu kiến trúc chi tiết của **Ứng Dụng Học Tập** được xây dựng theo Clean Architecture.

## 📋 Nội Dung

### 🎯 [Clean Architecture Overview](./clean-architecture.md)
Giải thích chi tiết về Clean Architecture pattern:
- Dependency Rule
- Layer separation
- Data flow
- Benefits

### 🔄 [Data Flow](./data-flow.md)
Luồng dữ liệu trong ứng dụng:
- Event → Bloc → UseCase → Repository
- State management
- Error handling
- Caching strategy

### 📚 [Source Code Documentation](./source-docs.md)
Tài liệu chi tiết về source code:
- Component descriptions
- API documentation
- Implementation details
- Code examples

## 🏛️ Kiến Trúc Tổng Quan

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   FlashCard     │  │   RandomText    │  │  MainMenu   │ │
│  │     Bloc        │  │     Bloc        │  │    Page     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Pages         │  │   Widgets       │  │   Events    │ │
│  │   & UI          │  │   Components    │  │   & States  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Entities      │  │   Use Cases     │  │ Repositories│ │
│  │   (Business     │  │   (Business     │  │ (Interfaces)│ │
│  │    Objects)     │  │    Logic)       │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│                       Data Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Models        │  │   Data Sources  │  │ Repository  │ │
│  │   (JSON         │  │   (Local DB,    │  │Implementations│ │
│  │   Serialization)│  │    Network)     │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Core Principles

### 1. Dependency Inversion
- High-level modules không phụ thuộc vào low-level modules
- Cả hai phụ thuộc vào abstractions
- Abstractions không phụ thuộc vào details

### 2. Separation of Concerns
- Mỗi layer có trách nhiệm riêng biệt
- UI logic tách biệt khỏi business logic
- Data access tách biệt khỏi business rules

### 3. Testability
- Dễ dàng unit test
- Mock dependencies
- Isolated components

### 4. Maintainability
- Code dễ đọc và hiểu
- Dễ mở rộng tính năng
- Dễ bảo trì

## 📁 Layer Descriptions

### 🎨 Presentation Layer
**Vị trí**: `lib/presentation/`

**Trách nhiệm**:
- UI/UX implementation
- User interactions
- State management với Bloc
- Navigation

**Components**:
- **Bloc**: State management
- **Pages**: Screen implementations
- **Widgets**: Reusable UI components
- **Events/States**: Bloc communication

### 🎯 Domain Layer
**Vị trí**: `lib/domain/`

**Trách nhiệm**:
- Business logic
- Use cases
- Entity definitions
- Repository interfaces

**Components**:
- **Entities**: Core business objects
- **Use Cases**: Application business rules
- **Repositories**: Data access contracts

### 🗄️ Data Layer
**Vị trí**: `lib/data/`

**Trách nhiệm**:
- Data persistence
- External API calls
- Data transformation
- Repository implementations

**Components**:
- **Models**: Data transfer objects
- **Data Sources**: Local/Remote data access
- **Repository Impl**: Concrete implementations

### 🔧 Core Layer
**Vị trí**: `lib/core/`

**Trách nhiệm**:
- Dependency injection
- Shared utilities
- Constants
- Error handling

## 🔄 Data Flow Example

### Flash Card Creation Flow
```
User Input → CreateFlashCardEvent → FlashCardBloc → CreateFlashCardUsecase → FlashCardRepository → SQLite Database
                ↓
UI Update ← FlashCardLoaded ← FlashCardBloc ← CreateFlashCardUsecase ← FlashCardRepository ← Database Response
```

### Random Text Selection Flow
```
User Input → ParseTextEvent → RandomTextBloc → ParseTextToItemsUsecase → RandomTextRepository → In-memory Processing
                ↓
UI Update ← RandomTextResult ← RandomTextBloc ← SelectRandomItemUsecase ← RandomTextRepository ← Processing Result
```

## 🧩 Design Patterns

### 1. Repository Pattern
```dart
abstract class FlashCardRepository {
  Future<List<FlashCard>> getAllFlashCards();
  Future<void> createFlashCard(FlashCard flashCard);
  Future<void> deleteFlashCard(String id);
}
```

### 2. Use Case Pattern
```dart
class CreateFlashCardUsecase {
  final FlashCardRepository repository;
  
  CreateFlashCardUsecase(this.repository);
  
  Future<void> call(FlashCard flashCard) {
    return repository.createFlashCard(flashCard);
  }
}
```

### 3. Bloc Pattern
```dart
class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final GetAllFlashCardsUsecase getAllFlashCards;
  final CreateFlashCardUsecase createFlashCard;
  final DeleteFlashCardUsecase deleteFlashCard;
  
  FlashCardBloc({...}) : super(FlashCardInitial()) {
    on<LoadFlashCards>(_onLoadFlashCards);
    on<CreateFlashCard>(_onCreateFlashCard);
    on<DeleteFlashCard>(_onDeleteFlashCard);
  }
}
```

## 🎨 UI Architecture

### Widget Hierarchy
```
MaterialApp
├── MainMenuPage
│   ├── Menu Cards
│   └── Navigation
├── FlashCardPage
│   ├── AppBar
│   ├── FlashCardGrid
│   └── FloatingActionButton
└── RandomTextPage
    ├── TextField
    ├── Button
    └── Result Display
```

### State Management
- **BlocProvider**: Provides bloc to widget tree
- **BlocConsumer**: Listens to state changes
- **BlocBuilder**: Rebuilds UI based on state

## 🔒 Error Handling

### Error Types
1. **Network Errors**: Connection issues
2. **Database Errors**: SQLite operations
3. **Validation Errors**: Input validation
4. **Business Logic Errors**: Use case failures

### Error Flow
```
Error Occurred → Repository → UseCase → Bloc → UI Error State → User Notification
```

## 🧪 Testing Strategy

### Unit Tests
- Use cases testing
- Repository testing
- Bloc testing

### Widget Tests
- UI component testing
- User interaction testing
- State change testing

### Integration Tests
- End-to-end flow testing
- Database integration testing
- Navigation testing

## 📊 Performance Considerations

### Memory Management
- Proper disposal of resources
- Efficient list rendering
- Image caching

### Database Optimization
- Proper indexing
- Query optimization
- Connection pooling

### UI Performance
- Efficient rebuilds
- Animation optimization
- Lazy loading

## 🔄 Future Enhancements

### Planned Features
- Offline-first architecture
- Cloud synchronization
- Advanced caching
- Background processing

### Architecture Improvements
- Modular architecture
- Plugin system
- Microservices integration

---

## 📞 Support

Để hiểu rõ hơn về kiến trúc:
1. Đọc [Clean Architecture Details](./clean-architecture.md)
2. Xem [Data Flow](./data-flow.md)
3. Tham khảo [Source Code Docs](./source-docs.md)

---

**Tài liệu được cập nhật theo sự phát triển của ứng dụng.**
