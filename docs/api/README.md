# 🔌 API Documentation

Tài liệu API và interfaces của **Ứng Dụng Học Tập**.

## 📋 Nội Dung

### 🎯 [Domain APIs](./domain-api.md)
APIs của Domain layer:
- Entity definitions
- Use case interfaces
- Repository contracts
- Business rules

### 🗄️ [Data APIs](./data-api.md)
APIs của Data layer:
- Model structures
- Data source interfaces
- Repository implementations
- Database schemas

### 📡 [Bloc Events](./bloc-events.md)
Documentation cho Bloc events và states:
- Event definitions
- State structures
- Event flow
- Error handling

## 🏗️ API Architecture Overview

### Domain Layer APIs
```
Entities
├── FlashCardEntity
└── RandomTextEntity

Use Cases
├── GetAllFlashCardsUsecase
├── CreateFlashCardUsecase
├── DeleteFlashCardUsecase
├── ParseTextToItemsUsecase
└── SelectRandomItemUsecase

Repositories (Interfaces)
├── FlashCardRepository
└── RandomTextRepository
```

### Data Layer APIs
```
Models
├── FlashCardModel
└── Generated Models

Data Sources
├── FlashCardLocalDataSource
└── FlashCardLocalDataSourceImpl

Repository Implementations
├── FlashCardRepositoryImpl
└── RandomTextRepositoryImpl
```

### Presentation Layer APIs
```
Blocs
├── FlashCardBloc
└── RandomTextBloc

Events
├── FlashCardEvent
└── RandomTextEvent

States
├── FlashCardState
└── RandomTextState
```

## 🎯 Domain Layer APIs

### Entities

#### FlashCardEntity
```dart
class FlashCardEntity {
  final String id;
  final String frontText;
  final String backText;
  final DateTime createdAt;
  
  const FlashCardEntity({
    required this.id,
    required this.frontText,
    required this.backText,
    required this.createdAt,
  });
}
```

#### RandomTextEntity
```dart
class RandomTextEntity {
  final List<String> items;
  final String selectedItem;
  final bool isShuffling;
  
  const RandomTextEntity({
    required this.items,
    required this.selectedItem,
    required this.isShuffling,
  });
}
```

### Use Cases

#### GetAllFlashCardsUsecase
```dart
class GetAllFlashCardsUsecase {
  final FlashCardRepository repository;
  
  GetAllFlashCardsUsecase(this.repository);
  
  Future<List<FlashCardEntity>> call() {
    return repository.getAllFlashCards();
  }
}
```

#### CreateFlashCardUsecase
```dart
class CreateFlashCardUsecase {
  final FlashCardRepository repository;
  
  CreateFlashCardUsecase(this.repository);
  
  Future<void> call(FlashCardEntity flashCard) {
    return repository.createFlashCard(flashCard);
  }
}
```

#### DeleteFlashCardUsecase
```dart
class DeleteFlashCardUsecase {
  final FlashCardRepository repository;
  
  DeleteFlashCardUsecase(this.repository);
  
  Future<void> call(String id) {
    return repository.deleteFlashCard(id);
  }
}
```

#### ParseTextToItemsUsecase
```dart
class ParseTextToItemsUsecase {
  final RandomTextRepository repository;
  
  ParseTextToItemsUsecase(this.repository);
  
  Future<List<String>> call(String inputText) {
    return repository.parseTextToItems(inputText);
  }
}
```

#### SelectRandomItemUsecase
```dart
class SelectRandomItemUsecase {
  final RandomTextRepository repository;
  
  SelectRandomItemUsecase(this.repository);
  
  String call(List<String> items) {
    return repository.selectRandomItem(items);
  }
}
```

### Repository Interfaces

#### FlashCardRepository
```dart
abstract class FlashCardRepository {
  Future<List<FlashCardEntity>> getAllFlashCards();
  Future<void> createFlashCard(FlashCardEntity flashCard);
  Future<void> deleteFlashCard(String id);
}
```

#### RandomTextRepository
```dart
abstract class RandomTextRepository {
  Future<List<String>> parseTextToItems(String inputText);
  String selectRandomItem(List<String> items);
}
```

## 🗄️ Data Layer APIs

### Models

#### FlashCardModel
```dart
@JsonSerializable()
class FlashCardModel {
  final String id;
  final String frontText;
  final String backText;
  final String createdAt;
  
  const FlashCardModel({
    required this.id,
    required this.frontText,
    required this.backText,
    required this.createdAt,
  });
  
  factory FlashCardModel.fromJson(Map<String, dynamic> json) =>
      _$FlashCardModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$FlashCardModelToJson(this);
  
  FlashCardEntity toEntity() {
    return FlashCardEntity(
      id: id,
      frontText: frontText,
      backText: backText,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
```

### Data Sources

#### FlashCardLocalDataSource
```dart
abstract class FlashCardLocalDataSource {
  Future<List<FlashCardModel>> getAllFlashCards();
  Future<void> createFlashCard(FlashCardModel flashCard);
  Future<void> deleteFlashCard(String id);
}
```

#### FlashCardLocalDataSourceImpl
```dart
class FlashCardLocalDataSourceImpl implements FlashCardLocalDataSource {
  final Database _database;
  
  FlashCardLocalDataSourceImpl({required Database database})
      : _database = database;
  
  @override
  Future<List<FlashCardModel>> getAllFlashCards() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('flash_cards');
    return List.generate(maps.length, (i) {
      return FlashCardModel.fromJson(maps[i]);
    });
  }
  
  @override
  Future<void> createFlashCard(FlashCardModel flashCard) async {
    await _database.insert('flash_cards', flashCard.toJson());
  }
  
  @override
  Future<void> deleteFlashCard(String id) async {
    await _database.delete('flash_cards', where: 'id = ?', whereArgs: [id]);
  }
}
```

### Repository Implementations

#### FlashCardRepositoryImpl
```dart
class FlashCardRepositoryImpl implements FlashCardRepository {
  final FlashCardLocalDataSource localDataSource;
  
  FlashCardRepositoryImpl({required this.localDataSource});
  
  @override
  Future<List<FlashCardEntity>> getAllFlashCards() async {
    final models = await localDataSource.getAllFlashCards();
    return models.map((model) => model.toEntity()).toList();
  }
  
  @override
  Future<void> createFlashCard(FlashCardEntity flashCard) async {
    final model = FlashCardModel(
      id: flashCard.id,
      frontText: flashCard.frontText,
      backText: flashCard.backText,
      createdAt: flashCard.createdAt.toIso8601String(),
    );
    await localDataSource.createFlashCard(model);
  }
  
  @override
  Future<void> deleteFlashCard(String id) async {
    await localDataSource.deleteFlashCard(id);
  }
}
```

## 📡 Bloc Events & States

### Flash Card Bloc

#### Events
```dart
abstract class FlashCardEvent {}

class LoadFlashCards extends FlashCardEvent {}

class CreateFlashCard extends FlashCardEvent {
  final FlashCardEntity flashCard;
  CreateFlashCard(this.flashCard);
}

class DeleteFlashCard extends FlashCardEvent {
  final String id;
  DeleteFlashCard(this.id);
}
```

#### States
```dart
abstract class FlashCardState {}

class FlashCardInitial extends FlashCardState {}

class FlashCardLoading extends FlashCardState {}

class FlashCardLoaded extends FlashCardState {
  final List<FlashCardEntity> flashCards;
  FlashCardLoaded(this.flashCards);
}

class FlashCardError extends FlashCardState {
  final String message;
  FlashCardError(this.message);
}
```

### Random Text Bloc

#### Events
```dart
abstract class RandomTextEvent {}

class ParseTextEvent extends RandomTextEvent {
  final String inputText;
  ParseTextEvent(this.inputText);
}

class StartShuffleEvent extends RandomTextEvent {
  final List<String> items;
  StartShuffleEvent(this.items);
}

class StopShuffleEvent extends RandomTextEvent {}

class UpdateResultEvent extends RandomTextEvent {
  final String result;
  UpdateResultEvent(this.result);
}
```

#### States
```dart
abstract class RandomTextState {}

class RandomTextInitial extends RandomTextState {
  final RandomTextEntity entity;
  RandomTextInitial(this.entity);
}

class RandomTextLoading extends RandomTextState {
  final RandomTextEntity entity;
  RandomTextLoading(this.entity);
}

class RandomTextShuffling extends RandomTextState {
  final RandomTextEntity entity;
  RandomTextShuffling(this.entity);
}

class RandomTextResult extends RandomTextState {
  final RandomTextEntity entity;
  RandomTextResult(this.entity);
}

class RandomTextError extends RandomTextState {
  final String message;
  final RandomTextEntity entity;
  RandomTextError(this.message, this.entity);
}
```

## 🔧 Dependency Injection

### GetIt Configuration
```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Bloc registration
  sl.registerFactory(() => FlashCardBloc(
    getAllFlashCards: sl(),
    createFlashCard: sl(),
    deleteFlashCard: sl(),
  ));
  
  sl.registerFactory(() => RandomTextBloc(
    parseTextToItemsUsecase: sl(),
    selectRandomItemUsecase: sl(),
  ));
  
  // Use case registration
  sl.registerLazySingleton(() => GetAllFlashCardsUsecase(sl()));
  sl.registerLazySingleton(() => CreateFlashCardUsecase(sl()));
  sl.registerLazySingleton(() => DeleteFlashCardUsecase(sl()));
  sl.registerLazySingleton(() => ParseTextToItemsUsecase(sl()));
  sl.registerLazySingleton(() => SelectRandomItemUsecase(sl()));
  
  // Repository registration
  sl.registerLazySingleton<FlashCardRepository>(
    () => FlashCardRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<RandomTextRepository>(
    () => RandomTextRepositoryImpl(),
  );
  
  // Data source registration
  sl.registerLazySingleton<FlashCardLocalDataSource>(
    () => FlashCardLocalDataSourceImpl(),
  );
}
```

## 🧪 API Testing

### Unit Test Examples
```dart
// Use case testing
test('should return list of flash cards when getAllFlashCards is called', () async {
  // Arrange
  when(mockRepository.getAllFlashCards()).thenAnswer((_) async => tFlashCards);
  
  // Act
  final result = await usecase();
  
  // Assert
  expect(result, tFlashCards);
  verify(mockRepository.getAllFlashCards());
});

// Repository testing
test('should return flash card models when getAllFlashCards is called', () async {
  // Arrange
  when(mockDataSource.getAllFlashCards()).thenAnswer((_) async => tFlashCardModels);
  
  // Act
  final result = await repository.getAllFlashCards();
  
  // Assert
  expect(result, tFlashCardEntities);
});
```

## 🔄 API Versioning

### Current Version: 1.0.0
- Initial API design
- Basic CRUD operations
- Local storage implementation

### Future Versions
- API versioning strategy
- Backward compatibility
- Migration guides

---

## 📞 Support

Để hiểu rõ hơn về APIs:
1. Xem [Domain APIs](./domain-api.md)
2. Tham khảo [Data APIs](./data-api.md)
3. Đọc [Bloc Events](./bloc-events.md)

---

**API documentation được cập nhật theo sự phát triển của ứng dụng.**
