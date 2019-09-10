import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/mainmodel.dart';
import '../../models/deadline.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../widgets/priority-indicator.dart';

class JobslistTask extends StatefulWidget {
  final MainModel model;
  final List<Deadline> tasks;
  final bool showCompletedTasksMode;
  final bool deadlineMode;
  final bool dense;
  final bool isWithinInfiniteWidget;

  JobslistTask({
    this.model,
    this.tasks,
    this.showCompletedTasksMode,
    this.deadlineMode,
    this.dense,
    this.isWithinInfiniteWidget,
  });

  _JobslistTaskState createState() => _JobslistTaskState();
}

class _JobslistTaskState extends State<JobslistTask> {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  final ScrollController _scroll2Controller = ScrollController();

  @override
  initState() {
    super.initState();
  }

  Future<bool> _confirmationDialog() {
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

  Future<Null> updateCompletionStatus(
      Deadline _task, MainModel model, bool completedStatus) {
    _task.isCompleted = completedStatus;
    return model.updateTask(_task.id, _task);
  }

  Widget _buildTrailingButton(
      BuildContext context, Deadline task, MainModel model) {
    return RaisedButton(
      onPressed: () => setState(() {
        widget.showCompletedTasksMode
            ? updateCompletionStatus(task, model, false).then((_) {
                model.getLocalTasksByDeadline();
                model.getAllTasksLocal(showCompleted: true);
              })
            : updateCompletionStatus(task, model, true).then((_) {
                widget.deadlineMode
                    ? model.getLocalTasksByDeadline()
                    : model.getAllTasksLocal(showIncompleted: true);
              });
      }),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: <Widget>[
          (widget.showCompletedTasksMode
              ? Icon(Icons.undo)
              : Icon(Icons.check_circle_outline)),
          (widget.showCompletedTasksMode
              ? Text(dict.displayWord('reassign', settings.language))
              : Text(dict.displayWord('done', settings.language))),
        ],
      ),
    );
  }

  Widget buildListTile(Deadline task, MainModel model) {
    return ListTile(
      leading: PriorityIndicator(task.calculatedPriority),
      title: Text(task.name),
      subtitle: widget.dense
          ? Container()
          : Text(task.getFormattedDeadline()[0].toString() +
              " " +
              dict.displayWord('days', settings.language) +
              ", " +
              task.getFormattedDeadline()[1].toString() +
              " " +
              dict.displayWord('hours', settings.language) +
              " " +
              dict.displayWord('remaining', settings.language) +
              "\n" +
              task.description),
      isThreeLine: true,
      trailing: widget.dense
          ? Container(
              width: 0.01,
            )
          : _buildTrailingButton(context, task, model),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/task/${task.id}",
        );
      },
    );
  }

  Widget _buildDismissible(BuildContext context, int index, MainModel model) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Deadline task = widget.tasks[index];
      return Card(
        child: Dismissible(
          //background: _dismissibleBackgroundStyle(),
          dismissThresholds: {DismissDirection.startToEnd: 0.8},
          confirmDismiss: (direction) => _confirmationDialog(),
          direction: DismissDirection.startToEnd,
          key: Key(task.id),
          onDismissed: (direction) => model.deleteTaskLocal(task.id),
          child: buildListTile(task, model),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Task List
     * If the TaskList is generated within an Expanded Tile,
     * a scrollController is needed to be scrollable.
     * Because the Expanded needs to constrain the height of the List View.
     * Otherwise there would be two infinite Widgets nested in each other
     */
    return widget.isWithinInfiniteWidget
        ? SingleChildScrollView(
            controller: _scroll2Controller,
            child: widget.model.areTasksLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: widget.tasks.length,
                    controller: _scroll2Controller,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _buildDismissible(context, index, widget.model),
                  ))

        /**
         * Task List
         * If the TaskList gets rendered just as list
         * It has to be wrapped inside a Scrollable Widget
         * It has to take the whole remaining space to be scrollable
         * This is realized by the Expanded widget
         */
        : Expanded(
            child: widget.model.areTasksLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: widget.tasks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        _buildDismissible(context, index, widget.model),
                  ));
  }
}
