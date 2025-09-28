import '../repositories/flash_card_repository.dart';

class DeleteFlashCardUsecase {
  final FlashCardRepository repository;

  DeleteFlashCardUsecase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteFlashCard(id);
  }
}
