import '../repositories/random_text_repository.dart';

class SelectRandomItemUsecase {
  final RandomTextRepository repository;

  SelectRandomItemUsecase(this.repository);

  String call(List<String> items) {
    return repository.selectRandomItem(items);
  }
}
