import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/models/job.dart';
import '../../models/deadline.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../scoped-models/mainmodel.dart';

class DismissibleJob extends StatelessWidget {
  final MainModel model;
  final List<Job> jobs;
  final dict = Dictionary();
  final settings = Settings();
  final int index;
  final Function listTileBuildFunction;

  DismissibleJob(
      {this.model, this.jobs, this.index, this.listTileBuildFunction});

  Widget _dismissibleBackgroundStyle(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          dict.displayWord('discard', settings.language),
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
              title: Text(
                  dict.displayPhrase("discardTaskTitle", settings.language)),
              content: Text(
                  dict.displayPhrase("discardTaskPrompt", settings.language)),
              actions: <Widget>[
                FlatButton(
                  child: Text(dict.displayWord('yes', settings.language)),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child: Text(dict.displayWord('no', settings.language)),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Job job = jobs[index];
      return Card(
        //TODO 8) Dismiss not working on Deadlines (state update not working correctly)
        child: Dismissible(
          background: _dismissibleBackgroundStyle(context),
          dismissThresholds: {DismissDirection.startToEnd: 0.8},
          confirmDismiss: (direction) => _confirmationDialog(context),
          direction: DismissDirection.startToEnd,
          key: Key(job.id),
          onDismissed: (direction) async {
            if (await model.deadlineExists(job.id))
              model.deleteDeadlineLocal(job.id);
            if (await model.taskExists(job.id)) model.deleteTaskLocal(job.id);
          },
          child: listTileBuildFunction(job, model),
        ),
      );
    });
  }
}
