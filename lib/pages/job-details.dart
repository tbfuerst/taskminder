import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';
import '../models/deadline.dart';
import '../helpers/date-time-helper.dart';
import '../dictionary.dart';
import '../globalSettings.dart';

class TaskDetails extends StatefulWidget {
  final String _deadlineId;
  final MainModel model;

  TaskDetails(this._deadlineId, this.model);

  _TaskDetailsState createState() => _TaskDetailsState();
}

// TODO 2: make Details Page abstract for use with both Tasks and Deadlines
class _TaskDetailsState extends State<TaskDetails> {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  Deadline _deadline;

  @override
  void initState() {
    _deadline = widget.model.deadlineById(widget._deadlineId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "${dict.displayWord('task', widget.model.settings.language)}: ${_deadline.name}"),
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
                    _deadline.name,
                    style: TextStyle(fontSize: 28.0),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 48.0),
                  child: Text(dict.displayWord(
                          'deadline', widget.model.settings.language) +
                      ": " +
                      DateTimeHelper()
                          .databaseDateStringToReadable(_deadline.deadline) +
                      DateTimeHelper().databaseTimeStringToReadable(
                          _deadline.deadlineTime)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_deadline.description),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(_deadline.priority.toString()),
                ),
                Container(
                  alignment: Alignment.center,
                  child:
                      Text("isCompleted: ${_deadline.isCompleted.toString()}"),
                ),
                Container(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    child: Text(dict.displayWord(
                        'edit', widget.model.settings.language)),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/deadlineedit/${widget._deadlineId}");
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
