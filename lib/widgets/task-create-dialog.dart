import 'package:flutter/material.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

import '../dictionary.dart';
import '../globalSettings.dart';
import 'priority-picker.dart';

class TaskCreateDialog extends StatefulWidget {
  final MainModel model;
  final Function addSimpleTaskCallback;

  TaskCreateDialog(this.model, {this.addSimpleTaskCallback});
  @override
  _TaskCreateDialogState createState() => _TaskCreateDialogState();
}

class _TaskCreateDialogState extends State<TaskCreateDialog> {
  Dictionary dict = Dictionary();
  Settings settings = Settings();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _textcontroller = new TextEditingController();

  String newTaskName;
  int _priority = 0;

  void _changePriority(int toPriority) {
    _priority = toPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  controller: _textcontroller,
                  onSaved: (String value) {
                    newTaskName = value;
                  },
                  validator: (String value) {
                    if (value.length == 0) {
                      return dict.displayPhrase('nameFormFieldEmptyError',
                          widget.model.settings.language);
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: dict.displayWord(
                        'addTask', widget.model.settings.language),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: PriorityPicker(_changePriority),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                dict.displayWord('priority', widget.model.settings.language),
                style: TextStyle(fontSize: 9),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: RaisedButton(
                  child: Text("SAVE"),
                  onPressed: () {
                    if (_formKey.currentState.validate() == false) {
                      return;
                    }
                    _formKey.currentState.save();
                    widget
                        .addSimpleTaskCallback(context,
                            taskName: newTaskName, priority: _priority)
                        .then((e) {
                      _textcontroller.text = "";
                      Navigator.pop(context, true);
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
