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

  MainTabs(this.model);

  Widget _mainDrawer(BuildContext context, MainModel model) {
    return Drawer(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Menu"),
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
            title: Text("Completed Tasks"),
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
              Text(Dictionary().displayWord("tasks", Settings().language)),
              Text(Dictionary().displayWord("deadlines", Settings().language)),
              Text(Dictionary().displayWord("calendar", Settings().language)),
              Text(Dictionary().displayWord("schedule", Settings().language)),
            ],
          ),
        ),
        body: TabBarView(children: [
          TasksTab(model),
          DeadlinesTab(),
          CalendarTab(),
          ScheduleTab(),
        ]),
      ),
    );
  }
}
