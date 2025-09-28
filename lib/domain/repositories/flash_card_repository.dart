import '../entities/flash_card.dart';

abstract class FlashCardRepository {
  Future<List<FlashCard>> getAllFlashCards();
  Future<FlashCard> createFlashCard(FlashCard flashCard);
  Future<void> deleteFlashCard(String id);
  Future<FlashCard?> getFlashCardById(String id);
}
