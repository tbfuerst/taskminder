import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import '../models/task.dart';
import '../scoped-models/mainmodel.dart';
import '../widgets/jobslist/jobslist-task.dart';
import '../widgets/priority-picker.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;
  final bool dialogOnFirstRender;
  TasksTab(this.model, this.dialogOnFirstRender);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  Dictionary dict = Dictionary();
  Settings settings = Settings();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _textcontroller = new TextEditingController();

  String newTaskName;
  int _priority = 0;

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: false, tasks: true);
    widget.model.getAllTasksLocal(showIncompleted: true);
    super.initState();
  }

  Future<bool> _addSimpleTask(taskName) {
    Task newTask = Task(
      //TODO: 4) adjust to new datastructure
      name: taskName,
      priority: _priority,
      isCompleted: false,
    );
    print(_priority);
    widget.model.insertTask(newTask).then((value) {
      setState(() {
        widget.model.getAllTasksLocal(showIncompleted: true);
      });
    });
    return Future<bool>.value(true);
  }

  void _changePriority(int toPriority) {
    _priority = toPriority;
  }

  void _addTaskDialogue() {
    showDialog(
      builder: (BuildContext context) {
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
                          return dict.displayPhrase(
                              'nameFormFieldEmptyError', settings.language);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText:
                            dict.displayWord('addTask', settings.language),
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
                    "Priority",
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
                        _addSimpleTask(newTaskName);
                        _textcontroller.text = "";
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      context: context,
    );
  }

  Widget _addTaskInputField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
          ),
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _changePriority(0);
              _addTaskDialogue();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
          onRefresh: () => model.getAllTasksLocal(showIncompleted: true),
          child: Column(
            children: <Widget>[
              _addTaskInputField(),
              model.areTasks2Loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : JobslistTask(
                      model: model,
                      tasks: model.tasks,
                      showCompletedOnly: false,
                    ),
            ],
          ),
        );
      },
    );
  }
}
