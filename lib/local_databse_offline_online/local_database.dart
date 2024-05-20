import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();

  factory LocalDatabase() => _instance;

  LocalDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE user (id INTEGER PRIMARY KEY, name TEXT, email TEXT)', // Ensure the column exists
        );
      },
    );
  }

  Future<void> insertUser(String name, String email) async {
    final db = await database;
    await db.insert(
      'user',
      {
        'name': name,
        'email': email,
      }, // Insert into the correct columns
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    return await db.query('user');
  }

  Future<void> clearUserTable() async {
    final db = await database;
    await db.delete('user');
  }
}
