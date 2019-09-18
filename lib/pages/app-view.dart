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

//TODO 8) other features

class AppView extends StatefulWidget {
  final MainModel model;
  final _activeTab;

  AppView(this.model, this._activeTab);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with SingleTickerProviderStateMixin {
  final Dictionary dict = Dictionary();

  final Settings settings = Settings();

  final int _tabLength = 4;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: _tabLength, initialIndex: widget._activeTab, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // updating app state on tab change
    setState(() {});
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
                Navigator.pushReplacementNamed(context, "/completedtasks"),
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

  TextStyle _tabTextStyle() {
    return TextStyle(fontSize: 9);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabLength,
      child: Scaffold(
        drawer: _mainDrawer(context, widget.model),
        floatingActionButton:
            _tabController.index == 2 ? null : AddTaskButton(widget.model),
        appBar: AppBar(
          title: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Text("Taskminder"),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Container(
                constraints: BoxConstraints.loose(
                  Size(double.infinity, 40.0),
                ),
                child: Tab(
                  icon: Icon(
                    Icons.calendar_today,
                    size: 16,
                  ),
                  child: Text(
                    dict.displayWord("calendar", settings.language),
                    style: _tabTextStyle(),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints.loose(
                  Size(double.infinity, 40.0),
                ),
                child: Tab(
                  icon: Icon(
                    Icons.assignment_late,
                    size: 16,
                  ),
                  child: Text(
                    dict.displayWord("deadlines", settings.language),
                    style: _tabTextStyle(),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints.loose(
                  Size(double.infinity, 40.0),
                ),
                child: Tab(
                  icon: Icon(
                    Icons.assignment,
                    size: 16,
                  ),
                  child: Text(
                    dict.displayWord("tasks", settings.language),
                    style: _tabTextStyle(),
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints.loose(
                  Size(double.infinity, 40.0),
                ),
                child: Tab(
                  icon: Icon(
                    Icons.device_hub,
                    size: 16,
                  ),
                  child: Text(
                    dict.displayWord("schedule", settings.language),
                    style: _tabTextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            CalendarTab(widget.model),
            DeadlinesTab(widget.model),
            TasksTab(widget.model),
            ScheduleTab()
          ],
        ),
      ),
    );
  }
}
