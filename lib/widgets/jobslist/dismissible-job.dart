import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/deadline.dart';
import '../../dictionary.dart';
import '../../globalSettings.dart';
import '../../scoped-models/mainmodel.dart';

class DismissibleJob extends StatelessWidget {
  final MainModel model;
  final List<Deadline> deadlines;
  final dict = Dictionary();
  final settings = Settings();
  final int index;
  final Function listTileBuildFunction;

  DismissibleJob(
      {this.model, this.deadlines, this.index, this.listTileBuildFunction});

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
      Deadline task = deadlines[index];
      return Card(
        child: Dismissible(
          background: _dismissibleBackgroundStyle(context),
          dismissThresholds: {DismissDirection.startToEnd: 0.8},
          confirmDismiss: (direction) => _confirmationDialog(context),
          direction: DismissDirection.startToEnd,
          key: Key(task.id),
          onDismissed: (direction) => model.deleteTaskLocal(task.id),
          child: listTileBuildFunction(task, model),
        ),
      );
    });
  }
}
