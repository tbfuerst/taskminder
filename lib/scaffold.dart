import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './dictionary.dart';
import './globalSettings.dart';
import './calendar/calendar.dart';
import './deadlines/deadlines.dart';
import './schedule/schedule.dart';
import './task/tasks.dart';

class TaskminderTabScaffold extends StatelessWidget {
  final List<Map<String, Widget>> _tabs = [
    {
      'tabName': Text(Dictionary().display("tasks", Settings().language)),
      'tabWidget': Tasks()
    },
    {
      'tabName': Text(Dictionary().display("deadlines", Settings().language)),
      'tabWidget': Deadlines()
    },
    {
      'tabName': Text(Dictionary().display("calendar", Settings().language)),
      'tabWidget': Calendar()
    },
    {
      'tabName': Text(Dictionary().display("schedule", Settings().language)),
      'tabWidget': Schedule()
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
