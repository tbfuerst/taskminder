import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';

import '../dictionary.dart';
import '../globalSettings.dart';

import '../tabs/calendar.dart';
import '../tabs/deadlines.dart';
import '../tabs/schedule.dart';
import '../tabs/tasks.dart';

class MainTabs extends StatelessWidget {
  final MainModel model;

  MainTabs(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/edittask');
              model.insertDummy();
            }),
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
