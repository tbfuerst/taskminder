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

class MainTabs extends StatefulWidget {
  final MainModel model;
  final _activeTab;

  MainTabs(this.model, this._activeTab);

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs>
    with SingleTickerProviderStateMixin {
  final Dictionary dict = Dictionary();

  final Settings settings = Settings();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, initialIndex: widget._activeTab, vsync: this);
  }

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
        drawer: _mainDrawer(context, widget.model),
        floatingActionButton: AddTaskButton(widget.model),
        appBar: AppBar(
          title: Text("Taskminder"),
          bottom: TabBar(
            controller: _tabController,
            labelPadding: EdgeInsets.all(15),
            tabs: [
              Text(dict.displayWord("deadlines", settings.language)),
              Text(dict.displayWord("tasks", settings.language)),
              Text(dict.displayWord("calendar", settings.language)),
              Text(dict.displayWord("schedule", settings.language)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            DeadlinesTab(widget.model),
            TasksTab(widget.model),
            CalendarTab(widget.model),
            ScheduleTab(),
          ],
        ),
      ),
    );
  }
}
