import '../../domain/entities/flash_card.dart';
import '../../domain/repositories/flash_card_repository.dart';
import '../datasources/local/flash_card_local_datasource.dart';
import '../models/flash_card_model.dart';

class FlashCardRepositoryImpl implements FlashCardRepository {
  final FlashCardLocalDataSource localDataSource;

  FlashCardRepositoryImpl({required this.localDataSource});

  @override
  Future<List<FlashCard>> getAllFlashCards() async {
    final flashCardModels = await localDataSource.getAllFlashCards();
    return flashCardModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<FlashCard> createFlashCard(FlashCard flashCard) async {
    final flashCardModel = FlashCardModel.fromEntity(flashCard);
    final createdFlashCard =
        await localDataSource.createFlashCard(flashCardModel);
    return createdFlashCard.toEntity();
  }

  @override
  Future<void> deleteFlashCard(String id) async {
    await localDataSource.deleteFlashCard(id);
  }

  @override
  Future<FlashCard?> getFlashCardById(String id) async {
    final flashCardModel = await localDataSource.getFlashCardById(id);
    return flashCardModel?.toEntity();
  }
}
