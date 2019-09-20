import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/models/job.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../scoped-models/mainmodel.dart';

class DismissibleJob extends StatefulWidget {
  final MainModel model;
  final List<Job> jobs;
  final int index;
  final Function listTileBuildFunction;

  DismissibleJob(
      {this.model, this.jobs, this.index, this.listTileBuildFunction});

  @override
  _DismissibleJobState createState() => _DismissibleJobState();
}

class _DismissibleJobState extends State<DismissibleJob> {
  final dict = Dictionary();

  final settings = Settings();

  Widget _dismissibleBackgroundStyle(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          dict.displayWord('discard', widget.model.settings.language),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      color: Theme.of(context).errorColor,
    );
  }

  Future<bool> _confirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(dict.displayPhrase(
                  "discardTaskTitle", widget.model.settings.language)),
              content: Text(dict.displayPhrase(
                  "discardTaskPrompt", widget.model.settings.language)),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      dict.displayWord('yes', widget.model.settings.language)),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child: Text(
                      dict.displayWord('no', widget.model.settings.language)),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Job job = widget.jobs[widget.index];
      return Card(
        child: Dismissible(
          background: _dismissibleBackgroundStyle(context),
          dismissThresholds: {DismissDirection.startToEnd: 0.8},
          confirmDismiss: (direction) => _confirmationDialog(context),
          direction: DismissDirection.startToEnd,
          key: Key(job.id),
          onDismissed: (direction) async {
            if (await model.deadlineExists(job.id))
              await model.deleteDeadlineLocal(job.id);

            if (await model.taskExists(job.id))
              await model.deleteTaskLocal(job.id);

            setState(() {});

            // TODO 3: Fix this dirty solution of state update!
            Navigator.pushReplacementNamed(context, "/deadlines");
          },
          child: widget.listTileBuildFunction(job, model),
        ),
      );
    });
  }
}
