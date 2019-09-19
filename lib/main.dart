import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';
import 'package:sqflite/sqflite.dart';

import './pages/app-view.dart';
import './pages/task-details.dart';
import './pages/task-edit.dart';
import './pages/block-edit.dart';
import './pages/completed-tasks.dart';
import './testclass.dart';
import './database/local-db.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(Taskminder());
}

class Taskminder extends StatelessWidget {
  final MainModel model = MainModel();

  @override
  Widget build(BuildContext context) {
    // Sqflite.devSetDebugModeOn(true);
    TestClass test = TestClass();
    test.test();
    LocalDB.db.deleteDB();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
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

          errorColor: Colors.brown[900],
        ),
        routes: {
          '/': (BuildContext context) => AppView(model, 0),
          '/deadlineedit': (BuildContext context) =>
              TaskEdit.create(model, "", ""),
          '/taskedit': (BuildContext context) =>
              AppView(model, 2, showTaskAddDialog: true),
          '/blockedit': (BuildContext context) => BlockEdit(),
          '/completedtasks': (BuildContext context) =>
              CompletedTasksPage(model),
          '/deadlines': (BuildContext context) => AppView(model, 1),
          '/tasks': (BuildContext context) =>
              AppView(model, 2, showTaskAddDialog: false),
          '/calendar': (BuildContext context) => AppView(model, 0),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          final String id = pathElements[2];

          if (pathElements[1] == "deadline") {
            return MaterialPageRoute(
                builder: (BuildContext context) => TaskDetails(id, model));
          }
          if (pathElements[1] == "taskedit") {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    TaskEdit.edit(model, id, ""));
          }
          if (pathElements[1] == "deadlineCalendar") {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    TaskEdit.fromCalendar(model, "", pathElements[2]));
          }
          return MaterialPageRoute(
              builder: (BuildContext context) => AppView(model, 1));
        },
      ),
    );
  }
}
