import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('purchases.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
  }

  Future<void> addPurchase(String item, int quantity, double price) async {
    final db = await instance.database;

    await db.insert('purchases', {
      'item': item,
      'quantity': quantity,
      'price': price,
    });
  }

  Future<List<Map<String, dynamic>>> getPurchases() async {
    final db = await instance.database;
    return await db.query('purchases');
  }

  Future<void> updatePurchase(int id, String item, int quantity, double price) async {
    final db = await instance.database;

    await db.update(
      'purchases',
      {
        'item': item,
        'quantity': quantity,
        'price': price,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePurchase(int id) async {
    final db = await instance.database;
    await db.delete('purchases', where: 'id = ?', whereArgs: [id]);
  }
}