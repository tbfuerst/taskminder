import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';
import 'dart:async' as async;
import '../models/task.dart';
import '../dictionary.dart';
import '../globalSettings.dart';
import '../widgets/priority-indicator.dart';

class TasksList extends StatefulWidget {
  final MainModel model;
  final List<Task> _tasks;

  TasksList(this.model, this._tasks);

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

  Widget _buildListTiles(BuildContext context, int index, MainModel model) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Task _task = widget._tasks[index];
      return Dismissible(
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
                  _task.isCompleted = true;
                  async.Timer(Duration(seconds: 1), () async {
                    model.updateTask(_task.id, _task).then((_) {
                      model.getAllTasksLocal(showIncompletedOnly: true);
                    });
                  });
                }),
            icon: Icon(Icons.cloud_done),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              "/task/${_task.id}",
            );
          },
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
