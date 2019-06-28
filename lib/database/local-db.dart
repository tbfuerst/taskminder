import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task.dart';

class LocalDB {
  Database _database;

  LocalDB._();

  static final LocalDB db = LocalDB._();

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
            // TODO Deadline time
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, timeInvestment INTEGER, deadline TEXT, onlyScheduled BOOLEAN, isCompleted BOOLEAN)");
      },
      version: 1,
    );
  }

  deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase(path);
  }

  Future<Task> insertTask(Task task) async {
    final db = await database;
    await db.insert("tasks", task.toMap());
    return task;
  }

  Future<Null> updateTask(String id, Task newTask) async {
    final db = await database;
    await db.update("tasks", newTask.toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete("tasks", where: 'id = ?', whereArgs: ["$id"]);
  }

  Future<List<Map<String, dynamic>>> fetchAllTasks() async {
    final db = await database;
    return await db.query("tasks", orderBy: 'priority');
  }

  Future fetchTasksByDeadline() async {
    final db = await database;
    return await db.query("tasks", groupBy: 'deadline');
  }
}
