import '../entities/flash_card.dart';
import '../repositories/flash_card_repository.dart';

class CreateFlashCardUsecase {
  final FlashCardRepository repository;

  CreateFlashCardUsecase(this.repository);

  Future<FlashCard> call(FlashCard flashCard) async {
    return await repository.createFlashCard(flashCard);
  }
}
