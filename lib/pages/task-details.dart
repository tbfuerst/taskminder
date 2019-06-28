import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';
import '../models/task.dart';
import '../helpers/date-time-helper.dart';
import '../dictionary.dart';
import '../globalSettings.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${Dictionary().displayWord('task', Settings().language)}: ${_task.name}"),
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
                  child: Text(Dictionary()
                          .displayWord('deadline', Settings().language) +
                      ": " +
                      DateTimeHelper()
                          .databaseDateStringToReadable(_task.deadline) +
                      DateTimeHelper()
                          .databaseTimeStringToReadable(_task.deadlineTime)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_task.description),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_task.priority.toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("isCompleted: ${_task.isCompleted.toString()}"),
                ),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text(
                        Dictionary().displayWord('edit', Settings().language)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/taskedit/${widget._taskId}");
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
