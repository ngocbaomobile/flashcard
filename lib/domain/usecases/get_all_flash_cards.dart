import '../entities/flash_card.dart';
import '../repositories/flash_card_repository.dart';

class GetAllFlashCardsUsecase {
  final FlashCardRepository repository;

  GetAllFlashCardsUsecase(this.repository);

  Future<List<FlashCard>> call() async {
    return await repository.getAllFlashCards();
  }
}
