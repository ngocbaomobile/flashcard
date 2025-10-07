import '../../domain/entities/random_text_entity.dart';
import '../../domain/repositories/random_text_repository.dart';

class RandomTextRepositoryImpl implements RandomTextRepository {
  @override
  Future<List<String>> parseTextToItems(String inputText) async {
    List<String> items = inputText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    return items;
  }

  @override
  String selectRandomItem(List<String> items) {
    if (items.isEmpty) {
      return 'Danh sách trống';
    }

    final random = DateTime.now().millisecondsSinceEpoch % items.length;
    return items[random];
  }
}
