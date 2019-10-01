// import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/pages/settings.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';
// import 'package:sqflite/sqflite.dart';

import './pages/app-view.dart';
import './pages/job-details.dart';
import './pages/deadline-edit.dart';
import './pages/block-edit.dart';
import './pages/completed-tasks.dart';
//import './testclass.dart';
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
    //TestClass test = TestClass();
    //test.test();
    LocalDB.db.deleteDB();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        title: 'Taskminder',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.tealAccent,
          errorColor: Colors.brown[900],
        ),
        routes: {
          '/': (BuildContext context) => AppView(model, 0),
          '/deadlineedit': (BuildContext context) =>
              DeadlineEdit.create(model, "", ""),
          '/taskedit': (BuildContext context) =>
              AppView(model, 2, showTaskAddDialog: true),
          '/blockedit': (BuildContext context) => BlockEdit(model),
          '/completedtasks': (BuildContext context) =>
              CompletedTasksPage(model),
          '/deadlines': (BuildContext context) => AppView(model, 1),
          '/tasks': (BuildContext context) =>
              AppView(model, 2, showTaskAddDialog: false),
          '/calendar': (BuildContext context) => AppView(model, 0),
          '/settings': (BuildContext context) => SettingsPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          final String id = pathElements[2];

          if (pathElements[1] == "deadlinedetail") {
            return MaterialPageRoute(
                builder: (BuildContext context) => TaskDetails(id, model));
          }
          if (pathElements[1] == "deadlineedit") {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    DeadlineEdit.edit(model, id, ""));
          }
          if (pathElements[1] == "deadlineCalendar") {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    DeadlineEdit.fromCalendar(model, "", pathElements[2]));
          }
          return MaterialPageRoute(
              builder: (BuildContext context) => AppView(model, 1));
        },
      ),
    );
  }
}
