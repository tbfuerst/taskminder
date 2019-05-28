import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './dictionary.dart';
import './globalSettings.dart';
import './calendar/calendar.dart';
import './deadlines/deadlines.dart';
import './schedule/schedule.dart';
import './task/tasks.dart';

class TaskminderTabScaffold extends StatefulWidget {
  TaskminderTabScaffold({Key key}) : super(key: key);

  _TaskminderTabScaffoldState createState() => _TaskminderTabScaffoldState();
}

class _TaskminderTabScaffoldState extends State<TaskminderTabScaffold>
    with SingleTickerProviderStateMixin {
  final Map appTabs = {
    'tabs': <Tab>[
      Tab(
        text: Dictionary().display("tasks", Settings().language),
      ),
      Tab(
        text: Dictionary().display("deadlines", Settings().language),
      ),
      Tab(
        text: Dictionary().display("calendar", Settings().language),
      ),
      Tab(
        text: Dictionary().display("schedule", Settings().language),
      ),
    ],
    'tabWidgets': <Widget>[Tasks(), Deadlines(), Calendar(), Schedule()]
  };

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: appTabs['tabs'].length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Taskminder"),
          bottom: TabBar(
            controller: _tabController,
            tabs: appTabs['tabs'],
          ),
        ),
        body: TabBarView(
            controller: _tabController, children: appTabs['tabWidgets']));
  }
}
