import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';
import '../models/task.dart';
import '../helpers/date-time-helper.dart';

class TaskDetails extends StatefulWidget {
  final String _taskId;
  final MainModel model;

  TaskDetails(this._taskId, this.model);

  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  Task _task;
  @override
  void initState() {
    _task = widget.model.taskById(widget._taskId);
    print(_task.deadline);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Aufgabe: ${_task.name}"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Card(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 32.0, left: 16.0, right: 16.0, bottom: 8.0),
                  alignment: Alignment.center,
                  child: Text(
                    _task.name,
                    style: TextStyle(fontSize: 28.0),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 48.0),
                  child: Text(
                      "Deadline: ${DateTimeHelper().databaseStringToReadable(_task.deadline)}"),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_task.description),
                ),
              ],
            ),
          ),
        ));
  }
}
