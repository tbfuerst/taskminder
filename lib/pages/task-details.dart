import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetails extends StatefulWidget {
  final String _taskId;

  TaskDetails(this._taskId);

  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget._taskId),
    );
  }
}
