import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'fitness.db';
  String tableName = 'fitness';

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
          id INTEGER NOT NULL,
          workoutName TEXT NOT NULL,
          duration TEXT NOT NULL,
          date TEXT NOT NULL,
          type TEXT NOT NULL
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<bool> fitnessExists(int id) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE id = ?
    ''';
    List<Map<String, Object?>> result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }

  Future<int> addFitnessToDatabase(int id, String title, String content,
      String date, String category) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName(
    id, workoutName, duration, date, type
    ) VALUES (?, ?, ?, ?, ?)
    ''';
    List args = [id, title, content, date, category];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readAllFitness(String title,String type) async {
    if(title!='')
    {
      final db = await database;
      String sql = '''
    SELECT * FROM $tableName WHERE type LIKE '$title%'
    ''';
      return db.rawQuery(sql);
    }else if(type!=''){
      final db = await database;
      String sql = '''
    SELECT * FROM $tableName WHERE type LIKE '$type%'
    ''';
      return db.rawQuery(sql);
    }
    else
    {
      final db = await database;
      String sql = '''
        SELECT * FROM $tableName
        ''';
      return await db.rawQuery(sql);
    }
  }

  Future<Future<List<Map<String, Object?>>>> readFitnessByTitle(
      String title) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE workoutName LIKE %'$title%'
    ''';
    return db.rawQuery(sql);
  }

  Future<int> updateFitness(int id, String title, String content, String date,
      String category) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET workoutName = ?, duration = ?, date = ?, type = ? WHERE id = ?
    ''';
    List args = [title, content, date, category, id];
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteFitness(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }

}
