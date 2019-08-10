import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import '../models/task.dart';
import '../scoped-models/mainmodel.dart';
import '../widgets/tasks-list.dart';

class TasksTab extends StatefulWidget {
  final MainModel model;

  TasksTab(this.model);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  Dictionary dict = Dictionary();
  Settings settings = Settings();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _textcontroller = new TextEditingController();

  String newTaskName;

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: false, tasks: true);
    widget.model.getAllTasksLocal(showIncompleted: true);
    super.initState();
  }

  Future<void> _addSimpleTask(taskName) {
    Task newTask = Task(
      //TODO: adjust to new datastructure
      name: taskName,
      hasDeadline: false,
      deadline: "19700101",
      deadlineTime: "0000",
      description: "",
      priority: 0,
      timeInvestment: 0,
    );
    widget.model.insertTask(newTask).then((value) {
      setState(() {
        widget.model.getAllTasksLocal(showIncompleted: true);
      });
    });
  }

  Widget _addTaskInputField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _textcontroller,
                onSaved: (String value) {
                  newTaskName = value;
                },
                validator: (String value) {
                  if (value.length == 0) {
                    return dict.displayPhrase(
                        'nameFormFieldEmptyError', settings.language);
                  }
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
                if (_formKey.currentState.validate() == false) {
                  return;
                }
                _formKey.currentState.save();
                _addSimpleTask(newTaskName);
                _textcontroller.text = "";
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
          onRefresh: () => model.getAllTasksLocal(showIncompleted: true),
          child: Column(
            children: <Widget>[
              _addTaskInputField(),
              model.areTasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : TasksList(
                      model: model,
                      tasks: model.tasks,
                      showCompletedTasksMode: false,
                      deadlineMode: false,
                      dense: true,
                    ),
            ],
          ),
        );
      },
    );
  }
}
