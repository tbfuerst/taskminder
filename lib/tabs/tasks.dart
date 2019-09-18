import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import '../models/deadline.dart';
import '../scoped-models/mainmodel.dart';
import '../widgets/jobslist/jobslist-task.dart';
import '../widgets/priority-picker.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;

  TasksTab(this.model);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  Dictionary dict = Dictionary();
  Settings settings = Settings();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  final TextEditingController _textcontroller = new TextEditingController();

  String newTaskName;

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: false, tasks: true);
    widget.model.getAllDeadlinesLocal(showIncompleted: true);
    super.initState();
  }

  Future<bool> _addSimpleTask(taskName) {
    Deadline newTask = Deadline(
      //TODO: 4) adjust to new datastructure
      name: taskName,
      deadline: "19700101",
      deadlineTime: "0000",
      description: "",
      priority: 0,
      timeInvestment: 0,
    );
    widget.model.insertDeadline(newTask).then((value) {
      setState(() {
        widget.model.getAllDeadlinesLocal(showIncompleted: true);
      });
    });
    return Future<bool>.value(true);
  }

  Widget _addTaskInputField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Expanded(
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
                  labelText: dict.displayWord('addTask', settings.language),
                ),
              ),
            ),
            flex: 4,
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    builder: (BuildContext context) {
                      return Card(
                        child: ListView(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Form(
                                    key: _formKey2,
                                    child: TextFormField(
                                      autofocus: true,
                                      controller: _textcontroller,
                                      onSaved: (String value) {
                                        newTaskName = value;
                                      },
                                      validator: (String value) {
                                        if (value.length == 0) {
                                          return dict.displayPhrase(
                                              'nameFormFieldEmptyError',
                                              settings.language);
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: dict.displayWord(
                                            'addTask', settings.language),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Container(
                                child: ButtonBar(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    FlatButton(
                                      color: Colors.grey[300],
                                      onPressed: () {},
                                      child: Text("--"),
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      child: Text("!"),
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      child: Text("!!!"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(" sfsdfsd"),
                            )
                          ],
                        ),
                      );
                    },
                    context: context);

/*                 if (_formKey.currentState.validate() == false) {
                  return;
                }
                _formKey.currentState.save();
                _addSimpleTask(newTaskName);
                _textcontroller.text = ""; */
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return RefreshIndicator(
          onRefresh: () => model.getAllDeadlinesLocal(showIncompleted: true),
          child: Column(
            children: <Widget>[
              _addTaskInputField(),
              model.areTasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : JobslistTask(
                      model: model,
                      tasks: model.deadlines,
                      showCompletedOnly: false,
                    ),
            ],
          ),
        );
      },
    );
  }
}
