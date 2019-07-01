import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';

import '../dictionary.dart';
import '../globalSettings.dart';

import '../tabs/calendar.dart';
import '../tabs/deadlines.dart';
import '../tabs/schedule.dart';
import '../tabs/tasks.dart';

import '../widgets/add-task-button.dart';

class MainTabs extends StatelessWidget {
  final MainModel model;
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();

  MainTabs(this.model);

  Widget _mainDrawer(BuildContext context, MainModel model) {
    return Drawer(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(dict.displayWord('mainmenu', settings.language)),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () =>
                Navigator.pushNamed(context, "/completedtasks").then((_) {
              Navigator.pop(context);
              model.getAllTasksLocal(showIncompleted: true);
            }),
            trailing: Icon(Icons.assignment_turned_in),
            title:
                Text(dict.displayPhrase('completedTasks', settings.language)),
          ),
          ListTile(
            onTap: () => print("lel"),
            trailing: Text(settings.language),
            title: Text(dict.displayWord('language', settings.language)),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: _mainDrawer(context, model),
        floatingActionButton: AddTaskButton(model),
        appBar: AppBar(
          title: Text("Taskminder"),
          bottom: TabBar(
            labelPadding: EdgeInsets.all(15),
            tabs: [
              Text(dict.displayWord("tasks", settings.language)),
              Text(dict.displayWord("list", settings.language)),
              Text(dict.displayWord("calendar", settings.language)),
              Text(dict.displayWord("schedule", settings.language)),
            ],
          ),
        ),
        body: TabBarView(children: [
          DeadlinesTab(model),
          TasksTab(model),
          CalendarTab(),
          ScheduleTab(),
        ]),
      ),
    );
  }
}
