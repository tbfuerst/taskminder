import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/mainmodel.dart';
import '../helpers/date-time-helper.dart';
import '../models/task.dart';

import '../dictionary.dart';
import '../globalSettings.dart';

class TaskEdit extends StatefulWidget {
  final MainModel _model;
  final String _taskId;

  TaskEdit.create(this._model, this._taskId);
  TaskEdit.edit(this._model, this._taskId);

  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  bool get isEditMode {
    return widget._taskId != "";
  }

  Task get editableTask {
    return widget._model.taskById(widget._taskId);
  }

  // Form Data
  String _name;
  String _description;
  int _prioValue = 3;
  String _pickedDate = DateTimeHelper().dateToDatabaseString(DateTime.now());
  String _displayedDate = DateTimeHelper().dateToReadableString(DateTime.now());
  String _pickedTime = DateTimeHelper().timeToDatabaseString(TimeOfDay.now());
  String _displayedTime =
      DateTimeHelper().timeToReadableString(TimeOfDay.now());
  int get priority {
    return (_sliderPriority / 10).round();
  }

  double _timeInvestmentSlider;

  int get _timeInvestment {
    return _timeInvestmentSlider.round();
  }

  bool _cbIsScheduled = false;

  int currentYear = DateTime.now().year;

  double _sliderPriority;

  String _textTimeInvestment;
  String _calculateTextTimeInvest() {
    if (_timeInvestmentSlider < 10) {
      return Dictionary().displayWord('minutes', Settings().language);
    } else if (_timeInvestmentSlider < 25) {
      return Dictionary().displayWord('few', Settings().language) +
          " " +
          Dictionary().displayWord('hours', Settings().language);
      ;
      ;
    } else if (_timeInvestmentSlider < 40) {
      return Dictionary().displayWord('some', Settings().language) +
          " " +
          Dictionary().displayWord('hours', Settings().language);
    } else if (_timeInvestmentSlider < 60) {
      return Dictionary().displayWord('many', Settings().language) +
          " " +
          Dictionary().displayWord('hours', Settings().language);
    } else if (_timeInvestmentSlider < 75) {
      return Dictionary().displayWord('few', Settings().language) +
          " " +
          Dictionary().displayWord('days', Settings().language);
    } else if (_timeInvestmentSlider < 95) {
      return Dictionary().displayWord('weeks', Settings().language);
    } else {
      return Dictionary().displayWord('month-s', Settings().language);
    }
  }

  @override
  initState() {
    _pickedDate = isEditMode
        ? editableTask.deadline
        : DateTimeHelper().dateToDatabaseString(DateTime.now());

    _displayedDate = isEditMode
        ? DateTimeHelper().databaseDateStringToReadable(editableTask.deadline)
        : DateTimeHelper().dateToReadableString(DateTime.now());

    _pickedTime = isEditMode
        ? editableTask.deadlineTime
        : DateTimeHelper().timeToDatabaseString(TimeOfDay.now());

    _displayedTime = isEditMode
        ? DateTimeHelper()
            .databaseTimeStringToReadable(editableTask.deadlineTime)
        : DateTimeHelper().timeToReadableString(TimeOfDay.now());

    _dateController.text = _displayedDate;
    _timeController.text = _displayedTime;

    _prioValue = isEditMode ? (editableTask.priority / 2).round() : 3;
    _timeInvestmentSlider =
        isEditMode ? editableTask.timeInvestment.toDouble() : 100;
    _cbIsScheduled = isEditMode ? editableTask.onlyScheduled : false;
    _textTimeInvestment = _calculateTextTimeInvest();
    super.initState();
  }

  _buildFirstRow() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: _buildNameField(),
        ),
        SizedBox(width: 100.0),
        Flexible(
          flex: 2,
          child: _buildPrioDropdown(),
        )
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: isEditMode ? editableTask.name : "",
      onSaved: (String value) {
        _name = value;
      },
      validator: (String value) {
        if (value.length == 0) {
          return Dictionary()
              .displayPhrase('nameFormFieldEmptyError', Settings().language);
        }
      },
      autofocus: true,
      decoration: InputDecoration(
          labelText: Dictionary().displayWord('name', Settings().language)),
    );
  }

  Widget _buildPrioDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          labelText: Dictionary().displayWord('priority', Settings().language)),
      value: _prioValue,
      onChanged: (newValue) {
        setState(() {
          _prioValue = newValue;
        });
      },
      items: [
        DropdownMenuItem(
          child: Text(Dictionary().displayWord('very', Settings().language) +
              " " +
              Dictionary().displayWord('low', Settings().language)),
          value: 1,
        ),
        DropdownMenuItem(
          child: Text(Dictionary().displayWord('low', Settings().language)),
          value: 2,
        ),
        DropdownMenuItem(
          child:
              Text(Dictionary().displayWord('standard', Settings().language)),
          value: 3,
        ),
        DropdownMenuItem(
          child: Text(Dictionary().displayWord('high', Settings().language)),
          value: 4,
        ),
        DropdownMenuItem(
          child: Text(Dictionary().displayWord('very', Settings().language) +
              " " +
              Dictionary().displayWord('high', Settings().language)),
          value: 5,
        ),
      ],
    );
  }

  Widget _buildDescrField() {
    return TextFormField(
      initialValue: isEditMode ? editableTask.description : "",
      onSaved: (String value) {
        _description = value;
      },
      decoration: InputDecoration(
          labelText:
              Dictionary().displayWord('description', Settings().language)),
      validator: (String value) {
        if (value.length > 128) {
          return Dictionary()
              .displayPhrase('descrFormFieldEmptyError', Settings().language);
        }
      },
    );
  }

  Future _datePicker() async {
    showDatePicker(
      context: context,
      initialDate: isEditMode
          ? DateTime.tryParse(editableTask.deadline)
          : DateTime.now(),
      firstDate: DateTime(currentYear),
      lastDate: DateTime(currentYear + 12),
      builder: (BuildContext context, Widget child) {
        return SingleChildScrollView(
          child: Theme(
            data: ThemeData.dark(),
            child: child,
          ),
        );
      },
    ).then((_date) {
      setState(() {
        _pickedDate = DateTimeHelper().dateToDatabaseString(_date);
        _displayedDate = DateTimeHelper().dateToReadableString(_date);
        _dateController.text = _displayedDate;
      });
    });
  }

  Future _timePicker() async {
    showTimePicker(
      context: context,
      initialTime: isEditMode
          ? TimeOfDay.fromDateTime(DateTime.tryParse(editableTask.deadline))
          : TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return SingleChildScrollView(
          child: Theme(
            data: ThemeData.dark(),
            child: child,
          ),
        );
      },
    ).then((_time) {
      setState(() {
        _pickedTime = DateTimeHelper().timeToDatabaseString(_time);
        _displayedTime = DateTimeHelper().timeToReadableString(_time);
        _timeController.text = _displayedTime;
      });
    });
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () {
        _datePicker();
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateController,
          //initialValue: _displayedDate,

          decoration: InputDecoration(
            labelText:
                Dictionary().displayWord('deadline', Settings().language),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: () {
        _timePicker();
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _timeController,
          //initialValue: _displayedDate,

          decoration: InputDecoration(
            labelText: Dictionary().displayWord('time', Settings().language),
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          flex: 3,
          child: _buildDateField(),
        ),
        SizedBox(width: 100.0),
        Flexible(
          flex: 2,
          child: _buildTimeField(),
        )
      ],
    );
  }

  Widget _buildTimeInvestmentSlider() {
    return Container(
        padding: EdgeInsets.only(top: 20.0, left: 2.0, right: 2.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                Dictionary().displayWord('timeInvestment', Settings().language),
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Slider(
                    value: _timeInvestmentSlider,
                    onChanged: (newValue) {
                      setState(() {
                        _timeInvestmentSlider = newValue;
                        _textTimeInvestment = _calculateTextTimeInvest();
                      });
                    },
                    min: 0,
                    max: 100,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(_textTimeInvestment),
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildCheckBox() {
    return GestureDetector(
      onTap: () => setState(() {
        _cbIsScheduled = !_cbIsScheduled;
      }),
      child: Container(
        child: Row(
          children: <Widget>[
            Checkbox(
              value: _cbIsScheduled,
              onChanged: (newValue) => setState(() {
                _cbIsScheduled = newValue;
              }),
            ),
            Text("nur geplante Aufgabe"),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Geplante Aufgaben"),
                    content: Text("Geplante Aufgaben sind...."),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(MainModel model) {
    return Container(
      child: RaisedButton(
        child: model.areTasksLoading
            ? Center(child: CircularProgressIndicator())
            : Text(Dictionary().displayWord('save', Settings().language)),
        onPressed: () async {
          if (_formKey.currentState.validate() == false) {
            return;
          }
          _formKey.currentState.save();
          Task task = _buildTask();
          isEditMode
              ? await model.updateTask(widget._taskId, task)
              : await model.insertTask(task);
          model
              .getAllTasksLocal(showIncompleted: true)
              .then((_) => Navigator.pushReplacementNamed(context, "/"));
        },
      ),
    );
  }

  Task _buildTask() {
    Task task = Task(
      name: _name,
      description: _description,
      deadline: _pickedDate,
      deadlineTime: _pickedTime,
      timeInvestment: _timeInvestment,
      priority: _prioValue * 2,
      onlyScheduled: _cbIsScheduled,
    );
    return task;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Text(Dictionary()
                    .displayPhrase('createTask', Settings().language)),
                margin: EdgeInsets.all(10.0),
              ),
              _buildFirstRow(),
              _buildDescrField(),
              _buildTimeInvestmentSlider(),
              _buildDeadlineRow(),
              _buildCheckBox(),
              ScopedModelDescendant<MainModel>(builder:
                  (BuildContext context, Widget child, MainModel model) {
                return _buildSubmitButton(model);
              })
            ],
          ),
        ),
      ),
    );
  }
}
