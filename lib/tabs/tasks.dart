import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';
import '../widgets/tasks-list.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;

  TasksTab(this.model);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  @override
  void initState() {
    widget.model.getAllTasksLocal(showIncompleted: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
          onRefresh: () => model.getAllTasksLocal(showIncompleted: true),
          child: TasksList(
            model: model,
            tasks: model.tasks,
            showCompletedTasksMode: false,
          ),
        );
      },
    );
  }
}
