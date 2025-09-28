import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/flash_card_model.dart';
import 'flash_card_local_datasource.dart';

class FlashCardLocalDataSourceImpl implements FlashCardLocalDataSource {
  static Database? _database;
  static const String _tableName = 'flash_cards';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'flash_cards.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        front_image_path TEXT NOT NULL,
        back_image_path TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<List<FlashCardModel>> getAllFlashCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return FlashCardModel.fromJson(maps[i]);
    });
  }

  @override
  Future<FlashCardModel> createFlashCard(FlashCardModel flashCard) async {
    final db = await database;
    await db.insert(_tableName, flashCard.toJson());
    return flashCard;
  }

  @override
  Future<void> deleteFlashCard(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<FlashCardModel?> getFlashCardById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FlashCardModel.fromJson(maps.first);
    }
    return null;
  }
}
