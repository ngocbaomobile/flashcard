import '../entities/random_text_entity.dart';

abstract class RandomTextRepository {
  Future<List<String>> parseTextToItems(String inputText);
  String selectRandomItem(List<String> items);
}
