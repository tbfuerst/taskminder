import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/task.dart';

class DBConnection {
  Future<Database> _database;

  DBConnection();

  Future<Database> get database {
    return _database;
  }

  Future<String> _initializePath() async {
    var databasesPath = await getDatabasesPath();
    String _path = join(databasesPath, 'taskminder.db');
    return _path;
  }

  Future rebuildDB() async {
// Open the database and store the reference.
    await _initializePath().then((path) async {
      await dropTable().then((e) {
        _database = openDatabase(
          // Set the path to the database.
          path,
          // When the database is first created, create a table to store dogs.
          onCreate: (Database db, int version) async {
            // Run the CREATE TABLE statement on the database.
            await db.execute(
              "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, deadline TEXT, onlyScheduled BOOLEAN)",
            );
          },
          version: 1,
        );
      });
    });
  }

  Future<Database> openDB() async {
// Open the database and store the reference.
    await _initializePath().then((path) {
      _database = openDatabase(
        // Set the path to the database.
        path,
        // When the database is first created, create a table to store dogs.
        onCreate: (Database db, int version) async {
          // Run the CREATE TABLE statement on the database.
          await db.execute(
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, deadline TEXT, onlyScheduled BOOLEAN)",
          );
        },
        version: 1,
      );
    });
    return database;
  }

  Future dropTable() async {
    await _initializePath().then((path) {
      print(path);
      deleteDatabase(path);
      print("Database deleted");
    });
  }

  Future<Database> insertDummyTask() async {
    await openDB().then((db) {
      Task task = Task(
        name: "test",
        description: "testdescription",
        priority: 2,
        deadline: "date",
        onlyScheduled: false,
      );
      db.insert('tasks', task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(task);
    });
    return database;
  }

  Future<List<Map>> fetchAllTasks() async {
    await openDB().then((db) async {
      List<Map> list = await db.rawQuery('SELECT * FROM tasks');
      return list;
    });
    return List();
  }
}
