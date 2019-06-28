import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';
import '../models/task.dart';
import '../dictionary.dart';
import '../globalSettings.dart';
import '../widgets/priority-indicator.dart';

class TasksList extends StatefulWidget {
  final MainModel model;
  final List<Task> tasks;
  final bool showCompletedTasksMode;

  TasksList({this.model, this.tasks, this.showCompletedTasksMode});

  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  initState() {
    super.initState();
  }

  Future<bool> _confirmationDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(Dictionary()
                  .displayPhrase("discardTaskTitle", Settings().language)),
              content: Text(Dictionary()
                  .displayPhrase("discardTaskPrompt", Settings().language)),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      Dictionary().displayWord('yes', Settings().language)),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child:
                      Text(Dictionary().displayWord('no', Settings().language)),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ));
  }

  Widget _dismissibleBackgroundStyle() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Text(
          Dictionary().displayWord(
            'discard',
            Settings().language,
          ),
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      color: Theme.of(context).errorColor,
    );
  }

  Future<Null> updateCompletionStatus(
      Task _task, MainModel model, bool completedStatus) {
    _task.isCompleted = completedStatus;
    return model.updateTask(_task.id, _task);
  }

  Widget _buildListTiles(BuildContext context, int index, MainModel model) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Task _task = widget.tasks[index];
      return Card(
        child: Dismissible(
          background: _dismissibleBackgroundStyle(),
          dismissThresholds: {DismissDirection.startToEnd: 0.8},
          confirmDismiss: (direction) => _confirmationDialog(),
          direction: DismissDirection.startToEnd,
          key: Key(_task.id),
          onDismissed: (direction) => model.deleteTaskLocal(_task.id),
          child: ListTile(
            leading: PriorityIndicator(_task.calculatedPriority),
            title: Text(_task.name),
            subtitle: Text(
                "${_task.getFormattedDeadline()[0]} Tage und ${_task.getFormattedDeadline()[1]} Stunden\n_${_task.description}"),
            isThreeLine: true,
            trailing: IconButton(
              onPressed: () => setState(() {
                    widget.showCompletedTasksMode
                        ? updateCompletionStatus(_task, model, false).then((_) {
                            model.getAllTasksLocal(showCompleted: true);
                          })
                        : updateCompletionStatus(_task, model, true).then((_) {
                            model.getAllTasksLocal(showIncompleted: true);
                          });
                  }),
              icon: widget.showCompletedTasksMode
                  ? Icon(Icons.undo)
                  : Icon(Icons.cloud_done),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                "/task/${_task.id}",
              );
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.model.areTasksLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: widget.model.tasksCount,
              itemBuilder: (context, index) =>
                  _buildListTiles(context, index, widget.model),
            ),
    );
  }
}
