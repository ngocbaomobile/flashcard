import '../repositories/random_text_repository.dart';

class ParseTextToItemsUsecase {
  final RandomTextRepository repository;

  ParseTextToItemsUsecase(this.repository);

  Future<List<String>> call(String inputText) {
    return repository.parseTextToItems(inputText);
  }
}
