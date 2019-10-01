import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/widgets/jobslist/jobslist-task.dart';
import '../dictionary.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/jobslist/jobslist-deadline.dart';

class CompletedTasksPage extends StatefulWidget {
  final MainModel model;

  CompletedTasksPage(
    this.model,
  );

  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  final Dictionary dict = Dictionary();
  int _navIndex = 0;
  @override
  void initState() {
    widget.model
        .getAllDeadlinesLocal(showCompleted: true, showIncompleted: false);
    widget.model.getAllTasksLocal(showCompleted: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, model.activeTabRoute);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
              dict.displayPhrase('completedTasks', model.settings.language)),
        ),
        body: _navIndex == 0
            ? widget.model.areDeadlinesLoading
                ? CircularProgressIndicator()
                : JobslistDeadline(
                    deadlines: widget.model.deadlines,
                    model: model,
                    showCompletedOnly: true,
                  )
            : widget.model.areTasksLoading
                ? CircularProgressIndicator()
                : Flex(direction: Axis.vertical, children: <Widget>[
                    JobslistTask(
                      tasks: widget.model.tasks,
                      model: model,
                      showCompletedOnly: true,
                    ),
                  ]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (newIndex) {
            setState(() {
              _navIndex = newIndex;
            });
          },
          currentIndex: _navIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_late),
              title: Text(
                dict.displayWord('deadlines', model.settings.language),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text(
                dict.displayWord('tasks', model.settings.language),
              ),
            ),
          ],
        ),
      );
    });
  }
}
