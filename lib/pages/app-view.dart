import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/pages/first-startup.dart';
import '../scoped-models/mainmodel.dart';

import '../dictionary.dart';

import '../tabs/calendar.dart';
import '../tabs/deadlines.dart';
import '../tabs/schedule.dart';
import '../tabs/tasks.dart';

import '../widgets/add-task-button.dart';

///TODO 3: new features -
///rework of completed tasks / deadlines -
///app color theme
///better first startup page -
///ui optimizations -
///export and import -
///pictures and geodata -
///scheduler

class AppView extends StatefulWidget {
  final MainModel model;

  final _activeTab;
  final bool showTaskAddDialog;

  AppView(this.model, this._activeTab, {this.showTaskAddDialog});

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with SingleTickerProviderStateMixin {
  final Dictionary dict = Dictionary();

  final int _tabLength = 4;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: _tabLength, initialIndex: widget._activeTab, vsync: this);
    _tabController.addListener(_handleTabChange);
    widget.model.querySettings().then((e) {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: Text(dict.displayWord('mainmenu', model.settings.language)),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () =>
                Navigator.pushReplacementNamed(context, "/completedtasks"),
            trailing: Icon(Icons.assignment_turned_in),
            title: Text(
                dict.displayPhrase('completedTasks', model.settings.language)),
          ),
          ListTile(
            onTap: () => Navigator.pushReplacementNamed(context, "/settings"),
            trailing: Icon(Icons.settings),
            title: Text(dict.displayWord('settings', model.settings.language)),
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, Model model) {
        return widget.model.isAppLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : widget.model.settings.firstStartup
                ? Scaffold(
                    //title: Container(child: Text("Welcome"),)
                    body: FirstStartup(),
                  )
                : DefaultTabController(
                    length: _tabLength,
                    child: Scaffold(
                      drawer: _mainDrawer(context, model),
                      floatingActionButton: _tabController.index == 2
                          ? null
                          : AddTaskButton(model),
                      appBar: AppBar(
                        title: Container(
                          child: Text("Taskminder"),
                        ),
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
                                  dict.displayWord("calendar",
                                      widget.model.settings.language),
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
                                  dict.displayWord("deadlines",
                                      widget.model.settings.language),
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
                                  dict.displayWord(
                                      "tasks", widget.model.settings.language),
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
                                  dict.displayWord("schedule",
                                      widget.model.settings.language),
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
                          CalendarTab(model),
                          DeadlinesTab(model),
                          TasksTab(model, widget.showTaskAddDialog),
                          ScheduleTab()
                        ],
                      ),
                    ),
                  );
      },
    );
  }
}
