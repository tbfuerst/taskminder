import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/deadline.dart';
import '../models/task.dart';
import '../models/block.dart';

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

    var database = await openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE deadlines(id TEXT PRIMARY KEY, name TEXT, type TEXT, description TEXT, priority INTEGER, timeInvestment INTEGER, deadline TEXT, deadlineTime TEXT, isCompleted BOOLEAN)",
        );
        await db.execute(
          "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, type TEXT, priority INTEGER, description TEXT, isCompleted BOOLEAN)",
        );
        await db.execute(
          "CREATE TABLE blocks(id TEXT PRIMARY KEY, name TEXT, type TEXT, deadline TEXT)",
        );
        await db.execute(
          "CREATE TABLE settings(id TEXT PRIMARY KEY, language TEXT, firstStartup TEXT, blockColor INTEGER, deadlineColor INTEGER, dayIndicatorColor INTEGER)",
        );
      },
      version: 1,
    );
/*     await insertSetting({
      'id': '1',
      'language': 'de',
    }); */
    return database;
  }

  Future<Null> insertSetting(Map<String, dynamic> setting) async {
    final db = await database;
    await db.insert("settings", setting);
  }

  Future<Null> updateSetting(Map<String, dynamic> setting) async {
    final db = await database;
    await db.update("settings", setting, where: "id = ?", whereArgs: ['1']);
  }

  Future<List<Map<String, dynamic>>> querySettings() async {
    final db = await database;
    return await db.query("settings", where: "id = ?", whereArgs: ['1']);
  }

  deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase(path);
  }

  Future<Deadline> insertDeadline(Deadline deadline) async {
    final db = await database;
    await db.insert("deadlines", deadline.toMap());
    return deadline;
  }

  Future<Task> insertTask(Task task) async {
    final db = await database;
    await db.insert("tasks", task.toMap());
    return task;
  }

  Future<Null> updateDeadline(String id, Deadline newDeadline) async {
    final db = await database;
    await db.update("deadlines", newDeadline.toMap(),
        where: "id = ?", whereArgs: [id]);
  }

  Future<Null> updateTask(String id, Task newTask) async {
    final db = await database;
    await db.update("tasks", newTask.toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteDeadline(String id) async {
    final db = await database;
    return await db.delete("deadlines", where: 'id = ?', whereArgs: ["$id"]);
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete("tasks", where: 'id = ?', whereArgs: ["$id"]);
  }

  Future<List<Map<String, dynamic>>> fetchAllDeadlines() async {
    final db = await database;
    return await db.query("deadlines", orderBy: 'priority');
  }

  Future<List<Map<String, dynamic>>> fetchAllTasks() async {
    final db = await database;
    return await db.query("tasks", orderBy: 'priority');
  }

  Future<Block> insertBlock(Block block) async {
    final db = await database;
    await db.insert("blocks", block.toMap());
    return block;
  }

  Future<Null> updateBlock(String deadline, Block newBlock) async {
    final db = await database;
    await db.update("blocks", newBlock.toMap(),
        where: "deadline = ?", whereArgs: [deadline]);
  }

  Future<Null> deleteBlock(String id) async {
    final db = await database;
    await db.delete("blocks", where: 'id = ?', whereArgs: ["$id"]);
  }

  Future<List<Map<String, dynamic>>> fetchBlockByDate(String date) async {
    final db = await database;
    return await db
        .query("blocks", where: 'deadline = ?', whereArgs: ["$date"]);
  }

  Future<List<Map<String, dynamic>>> fetchAllBlocks() async {
    final db = await database;
    return await db.query("blocks");
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllJobs() async {
    List<Map<String, dynamic>> blocks = await fetchAllBlocks();
    List<Map<String, dynamic>> deadlines = await fetchAllDeadlines();
    List<Map<String, dynamic>> tasks = await fetchAllTasks();
    return {
      'tasks': tasks,
      'deadlines': deadlines,
      'blocks': blocks,
    };
  }

  Future<List<Map<String, dynamic>>> checkDeadlineId(String id) async {
    final db = await database;
    return await db.query("deadlines", where: 'id = ?', whereArgs: ["$id"]);
  }

  Future<List<Map<String, dynamic>>> checkTaskId(String id) async {
    final db = await database;
    return await db.query("tasks", where: 'id = ?', whereArgs: ["$id"]);
  }
}
