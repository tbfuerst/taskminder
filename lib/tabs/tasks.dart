import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';
import '../models/task.dart';
import '../dictionary.dart';
import '../globalSettings.dart';
import '../widgets/priority-indicator.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;

  TasksTab(this.model);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  @override
  void initState() {
    widget.model.getAllTasksLocal();
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
      Task _task = model.tasks[index];
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
          subtitle: Text(_task.description +
              "   " +
              _task.deadline + "   "+

              _task.timeToDeadline.round().toString() +
              "   " +
              _task.priority.toString() +
              "   "),
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
          onRefresh: () => model.getAllTasksLocal(),
          child: Container(
            child: model.areTasksLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: model.tasksCount,
                    itemBuilder: (context, index) =>
                        _buildListTiles(context, index, model),
                  ),
          ),
        );
      },
    );
  }
}
