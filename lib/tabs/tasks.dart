import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';

import 'package:taskminder/widgets/task-create-dialog.dart';
import '../models/task.dart';
import '../scoped-models/mainmodel.dart';
import '../widgets/jobslist/jobslist-task.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;
  final bool dialogOnFirstRender;
  TasksTab(this.model, this.dialogOnFirstRender);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  Dictionary dict = Dictionary();

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: false, tasks: true);
    widget.model.getAllTasksLocal(showIncompleted: true);
    super.initState();
  }

  Future<bool> _addSimpleTask(BuildContext context, {taskName, priority}) {
    Task newTask = Task(
      name: taskName,
      priority: priority,
      isCompleted: false,
    );
    print(newTask.priority);
    widget.model.insertTask(newTask).then((value) {
      setState(() {
        widget.model.getAllTasksLocal(showIncompleted: true);
      });
    });
    return Future<bool>.value(true);
  }

  void _addTaskDialogue() {
    showDialog(
      builder: (BuildContext context) {
        return TaskCreateDialog(
          widget.model,
          addSimpleTaskCallback: _addSimpleTask,
        );
      },
      context: context,
    );
  }

  Widget _addTaskInputField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
          ),
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addTaskDialogue();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
          onRefresh: () => model.getAllTasksLocal(showIncompleted: true),
          child: Column(
            children: <Widget>[
              _addTaskInputField(),
              model.areTasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : JobslistTask(
                      model: model,
                      tasks: model.tasks,
                      showCompletedOnly: false,
                    ),
            ],
          ),
        );
      },
    );
  }
}
