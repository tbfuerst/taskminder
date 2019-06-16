import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dictionary.dart';
import '../globalSettings.dart';
import '../tabs/calendar.dart';
import '../tabs/deadlines.dart';
import '../tabs/schedule.dart';
import '../tabs/tasks.dart';

class MainTabs extends StatelessWidget {
  final List<Map<String, Widget>> _tabs = [
    {
      'tabName': Text(Dictionary().display("tasks", Settings().language)),
      'tabWidget': TasksTab()
    },
    {
      'tabName': Text(Dictionary().display("deadlines", Settings().language)),
      'tabWidget': DeadlinesTab()
    },
    {
      'tabName': Text(Dictionary().display("calendar", Settings().language)),
      'tabWidget': CalendarTab()
    },
    {
      'tabName': Text(Dictionary().display("schedule", Settings().language)),
      'tabWidget': ScheduleTab()
    },
  ];

  List<Widget> _getTabWidgets(List<Map<String, Widget>> tabs) {
    return _tabs.map((_tab) {
      return _tab['tabWidget'];
    }).toList();
  }

  List<Widget> _getTabs(List<Map<String, Widget>> tabs) {
    return tabs.map((_tab) {
      return Tab(
        child: _tab['tabName'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Taskminder"),
          bottom: TabBar(tabs: _getTabs(_tabs)),
        ),
        body: TabBarView(children: _getTabWidgets(_tabs)),
      ),
    );
  }
}
