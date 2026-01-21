import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:daily_app/models/financial.dart';
import 'package:daily_app/models/task.dart';

class DB {
  static Database? _db;

  static Future<Database> open() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'database.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date INTEGER NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            completed INTEGER
          )
      ''');
        await db.execute('''
          CREATE TABLE financials(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date INTEGER NOT NULL,
            amount REAL,
            receiver TEXT,
            description TEXT
          )
      ''');
      },
    );
    return _db!;
  }

  // ------------------ Database operations for Tasks ------------------ 

  static Future<Task?> addTask(String title, String description) async {
    final db = await DB.open();
    final date = DateTime.now();
    final id = await db.insert('tasks', {
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'description': description,
      'completed': 0,
    });
    if (id <= 0) return null;
    return Task(
      id: id,
      date: date,
      title: title,
      description: description,
    );
  }

  static Future<void> updateTask(Task task) async {
    final db = await DB.open();
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<Task?> getTaskById(int id) async {
    final db = await DB.open();
    List<Map<String, Object?>> result = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    Map<String, Object?> first = result[0];
    return Task.fromMap(first);
  }

  static Future<void> deleteTask(Task task) async {
    final db = await DB.open();
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<List<Task>> getAllTasks() async {
    final db = await open();
    final rows = await db.query('tasks');

    return rows.map((row) => Task.fromMap(row)).toList();
  }

  // ------------------ Database operations for Financials ------------------ 

  static Future<Financial?> addFinancial(double amount, String receiver, String description) async {
    final db = await DB.open();
    final date = DateTime.now();
    final id = await db.insert('financials', {
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'receiver': receiver,
      'description': description,
    });
    if (id <= 0) return null;
    return Financial(
      id: id,
      date: date,
      amount: amount,
      receiver: receiver,
      description: description,
    );
  }

  static Future<void> updateFinancial(Financial financial) async {
    final db = await DB.open();
    await db.update(
      'financials',
      financial.toMap(),
      where: 'id = ?',
      whereArgs: [financial.id],
    );
  }

  static Future<Financial?> getFinancialById(int id) async {
    final db = await DB.open();
    List<Map<String, Object?>> result = await db.query(
      'financials',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    Map<String, Object?> first = result[0];
    return Financial.fromMap(first);
  }

  static Future<void> deleteFinancial(Financial financial) async {
    final db = await DB.open();
    await db.delete('financials', where: 'id = ?', whereArgs: [financial.id]);
  }

  static Future<List<Financial>> getAllFinancials() async {
    final db = await open();
    final rows = await db.query('financials');

    return rows.map((row) => Financial.fromMap(row)).toList();
  }
}
