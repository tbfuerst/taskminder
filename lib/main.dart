import 'package:flutter/material.dart';

import './pages/maintabs.dart';
import './models/task.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() => runApp(Taskminder());

class Taskminder extends StatelessWidget {
  Future _dbGetPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'taskminder.db');
    return path;
  }

  _dbOpen() async {
// Open the database and store the reference.
    await _dbGetPath().then((path) {
      print(path);
      final Future<Database> database = openDatabase(
        // Set the path to the database.
        path,
        // When the database is first created, create a table to store dogs.
        onCreate: (Database db, int version) async {
          // Run the CREATE TABLE statement on the database.
          await db.execute(
            "CREATE TABLE tasks(id TEXT PRIMARY KEY, name TEXT, description TEXT, priority INTEGER, deadline TEXT)",
          );
        },
        version: 1,
      );
      return database;
    }).then((database) async {
      Task task = Task(
          name: "test",
          description: "testdescription",
          priority: 2,
          deadline: "date");
      database.insert('tasks', task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(task);
      return database;
    }).then((database) async {
      List<Map> list = await database.rawQuery('SELECT * FROM tasks');
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    _dbOpen();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        accentColor: Colors.tealAccent,
      ),
      home: MainTabs(),
    );
  }
}
