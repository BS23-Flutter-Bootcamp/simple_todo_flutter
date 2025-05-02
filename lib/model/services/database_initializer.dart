import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInitializer {
  static final DatabaseInitializer instance = DatabaseInitializer._init();
  static Database? _database;

  DatabaseInitializer._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT NOT NULL,
      title TEXT NOT NULL,
      dueDate TEXT,
      description TEXT,
      isCompleted INTEGER NOT NULL DEFAULT 0,
      lastModified TEXT NOT NULL,
      syncStatus TEXT NOT NULL DEFAULT 'pending'
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS tasks');
      await _createDB(db, newVersion);
    }
    if (oldVersion < 3) {
      await db.execute(
        'ALTER TABLE tasks ADD COLUMN isCompleted INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 4) {
      await db.execute(
        'ALTER TABLE tasks ADD COLUMN userId TEXT NOT NULL DEFAULT ""',
      );
      await db.execute(
        'ALTER TABLE tasks ADD COLUMN lastModified TEXT NOT NULL DEFAULT "2025-01-01T00:00:00Z"',
      );
      await db.execute(
        'ALTER TABLE tasks ADD COLUMN syncStatus TEXT NOT NULL DEFAULT "pending"',
      );
    }
  }
}
