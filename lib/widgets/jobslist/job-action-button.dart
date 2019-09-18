import 'package:flutter/material.dart';

import '../../models/job.dart';
import '../../models/deadline.dart';

import '../../scoped-models/mainmodel.dart';

import '../../dictionary.dart';
import '../../globalSettings.dart';

class JobActionButton extends StatelessWidget {
  final Job job;
  final MainModel model;
  final bool showCompletedOnly;
  final bool isTaskNotDeadline;
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();

  JobActionButton(
      {this.job, this.model, this.showCompletedOnly, this.isTaskNotDeadline});

  Future<Null> updateCompletionStatus(
      Job _job, MainModel model, bool completedStatus) async {
    _job.isCompleted = completedStatus;
    if (await model.deadlineExists(_job.id))
      return model.updateDeadline(_job.id, _job);
    if (await model.taskExists(_job.id)) return model.updateTask(_job.id, _job);
  }

  buttonFunction() async {
    showCompletedOnly
        ? updateCompletionStatus(job, model, false).then((_) {
            model.getLocalDeadlinesByDeadline();
            model.getAllTasksLocal(showCompleted: true);
            model.getAllDeadlinesLocal(showCompleted: true);
          })
        : updateCompletionStatus(job, model, true).then((_) {
            model.getLocalDeadlinesByDeadline();
            model.getAllTasksLocal(showIncompleted: true);
            model.getAllDeadlinesLocal(showIncompleted: true);
          });
  }

  @override
  Widget build(BuildContext context) {
    return isTaskNotDeadline
        ? IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: () => buttonFunction(),
          )
        : RaisedButton(
            onPressed: () => buttonFunction(),
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: <Widget>[
                (showCompletedOnly
                    ? Icon(Icons.undo)
                    : Icon(Icons.check_circle_outline)),
                (showCompletedOnly
                    ? Text(dict.displayWord('reassign', settings.language))
                    : Text(dict.displayWord('done', settings.language))),
              ],
            ),
          );
  }
}
