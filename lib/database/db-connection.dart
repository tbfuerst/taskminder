import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:random_string/random_string.dart';

import '../models/task.dart';

class DBConnection {
  String _path;
  Database _database;

  DBConnection._();

  static final DBConnection db = DBConnection._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = await getDatabasesPath();
    path = join(path, 'taskminder.db');

    return await openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, deadline TEXT, onlyScheduled BOOLEAN)");
      },
      version: 1,
    );
  }

  deleteDB() async {
    await deleteDatabase(_path);
  }

  insertTask(Task task) async {
    final db = await database;
    await db.insert("tasks", task.toMap());
  }

  insertDummyTask() async {
    Task task = Task(
      name: randomString(5),
      description: randomString(25),
      deadline: "31.12.2018",
      priority: 5,
      onlyScheduled: false,
    );
    await insertTask(task);
  }

  fetchAllData() async {
    final db = await database;
    return await db.query("tasks");
  }
}
