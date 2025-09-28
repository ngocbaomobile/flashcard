import '../../models/flash_card_model.dart';

abstract class FlashCardLocalDataSource {
  Future<List<FlashCardModel>> getAllFlashCards();
  Future<FlashCardModel> createFlashCard(FlashCardModel flashCard);
  Future<void> deleteFlashCard(String id);
  Future<FlashCardModel?> getFlashCardById(String id);
}
