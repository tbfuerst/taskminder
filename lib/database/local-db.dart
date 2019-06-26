import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

import 'package:random_string/random_string.dart';

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
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, deadline TEXT, onlyScheduled BOOLEAN)");
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

  Future<Task> insertDummyTask() async {
    final int day = Random().nextInt(27) + 1;
    final int month = Random().nextInt(2) + 6;
    final int year = 2019;

    final String dl = year.toString() +
        month.toString().padLeft(2, "0") +
        day.toString().padLeft(2, "0");

    final Task task = Task(
      name: randomString(5),
      description: randomString(25),
      deadline: dl,
      priority: Random().nextInt(9) + 1,
      onlyScheduled: false,
    );
    await insertTask(task);
    return task;
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
