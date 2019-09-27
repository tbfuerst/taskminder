import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/models/block.dart';
import 'package:taskminder/widgets/blocked-deadline-dialog.dart';
import 'package:taskminder/widgets/priority-picker.dart';

import '../scoped-models/mainmodel.dart';
import '../helpers/date-time-helper.dart';
import '../models/deadline.dart';

import '../dictionary.dart';

class DeadlineEdit extends StatefulWidget {
  final MainModel _model;
  final String _deadlineId;
  final String _dateFromCalendar;

  DeadlineEdit.create(this._model, this._deadlineId, this._dateFromCalendar);
  DeadlineEdit.edit(this._model, this._deadlineId, this._dateFromCalendar);
  DeadlineEdit.fromCalendar(
      this._model, this._deadlineId, this._dateFromCalendar);

  _DeadlineEditState createState() => _DeadlineEditState();
}

class _DeadlineEditState extends State<DeadlineEdit> {
  final Dictionary dict = Dictionary();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  /// true, if an existing deadline should be edited
  bool get isEditMode {
    return widget._deadlineId != "";
  }

  /// true, if the edit page is brought up by tapping on a day in calendar page
  bool get isCalendarMode {
    return widget._dateFromCalendar != "";
  }

  /// get Deadline Object provided by the calling parent widget
  Deadline get editableDeadline {
    return widget._model.deadlineById(widget._deadlineId);
  }

  // Form Data
  String _name;
  String _description;
  int _prioValue = 1;
  String _pickedDate = DateTimeHelper()
      .dateToDatabaseString(DateTime.now()); // Date as database String
  String _displayedDate = DateTimeHelper()
      .dateToReadableString(DateTime.now()); // Date as displayed in app
  String _pickedTime = DateTimeHelper()
      .timeToDatabaseString(TimeOfDay.now()); // Time as database String
  String _displayedTime = DateTimeHelper()
      .timeToReadableString(TimeOfDay.now()); // Time as displayed in app
  int get priority {
    return _prioValue;
  }

  double _timeInvestmentSlider;

  int get _timeInvestment {
    return _timeInvestmentSlider.round();
  }

  int currentYear = DateTime.now().year;

  String _textTimeInvestment;
  String _calculateTextTimeInvest() {
    if (_timeInvestmentSlider < 10) {
      return dict.displayWord('minutes', widget._model.settings.language);
    } else if (_timeInvestmentSlider < 25) {
      return dict.displayWord('circashort', widget._model.settings.language) +
          " 1 " +
          dict.displayWord('hour', widget._model.settings.language);
    } else if (_timeInvestmentSlider < 40) {
      return dict.displayWord('some', widget._model.settings.language) +
          " " +
          dict.displayWord('hours', widget._model.settings.language);
    } else if (_timeInvestmentSlider < 60) {
      return dict.displayWord('many', widget._model.settings.language) +
          " " +
          dict.displayWord('hours', widget._model.settings.language);
    } else if (_timeInvestmentSlider < 75) {
      return dict.displayWord('few', widget._model.settings.language) +
          " " +
          dict.displayWord('days', widget._model.settings.language);
    } else if (_timeInvestmentSlider < 95) {
      return dict.displayWord('weeks', widget._model.settings.language);
    } else {
      return dict.displayWord('month-s', widget._model.settings.language);
    }
  }

  @override
  initState() {
    _pickedDate = isEditMode
        ? editableDeadline.deadline
        : isCalendarMode
            ? widget._dateFromCalendar
            : DateTimeHelper().dateToDatabaseString(DateTime.now());

    _displayedDate = isEditMode
        ? DateTimeHelper()
            .databaseDateStringToReadable(editableDeadline.deadline)
        : isCalendarMode
            ? DateTimeHelper()
                .databaseDateStringToReadable(widget._dateFromCalendar)
            : DateTimeHelper().dateToReadableString(DateTime.now());

    _pickedTime = isEditMode
        ? editableDeadline.deadlineTime
        : DateTimeHelper().timeToDatabaseString(TimeOfDay.now());

    _displayedTime = isEditMode
        ? DateTimeHelper()
            .databaseTimeStringToReadable(editableDeadline.deadlineTime)
        : DateTimeHelper().timeToReadableString(TimeOfDay.now());

    _dateController.text = _displayedDate;
    _timeController.text = _displayedTime;

    _prioValue = isEditMode ? editableDeadline.priority : 1;
    _timeInvestmentSlider =
        isEditMode ? editableDeadline.timeInvestment.toDouble() : 17;
    // _cbIsScheduled = isEditMode ? editableDeadline.hasDeadline : false;
    _textTimeInvestment = _calculateTextTimeInvest();
    super.initState();
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: isEditMode ? editableDeadline.name : "",
      onSaved: (String value) {
        _name = value;
      },
      validator: (String value) {
        if (value.length == 0) {
          return dict.displayPhrase(
              'nameFormFieldEmptyError', widget._model.settings.language);
        }
        return null;
      },
      autofocus: true,
      decoration: InputDecoration(
          labelText: dict.displayWord('name', widget._model.settings.language)),
    );
  }

  Widget _buildPrioBar() {
    void _changePriority(int to) {
      _prioValue = to;
    }

    return PriorityPicker(_changePriority);
  }

  Widget _buildDescrField() {
    return TextFormField(
      initialValue: isEditMode ? editableDeadline.description : "",
      onSaved: (String value) {
        _description = value;
      },
      decoration: InputDecoration(
          labelText:
              dict.displayWord('description', widget._model.settings.language)),
      validator: (String value) {
        if (value.length > 128) {
          return dict.displayPhrase(
              'descrFormFieldEmptyError', widget._model.settings.language);
        }
        return null;
      },
    );
  }

  Future _datePicker() async {
    showDatePicker(
      context: context,
      //TODO minor: check if initialDate is a Block
      initialDate: isEditMode
          ? DateTime.tryParse(editableDeadline.deadline)
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
      List<Block> _blocks = widget._model.blocks;
      List<Block> _blocked = _blocks.where((block) {
        return DateTime.parse(block.deadline).difference(_date).inDays == 0;
      }).toList();
      if (_blocked.length > 0) {
        showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return BlockedDeadlineDialog(widget._model, pickedDate: _date);
            }).then((result) {
          print(result);
          if (result == false)
            _datePicker();
          else {
            setState(() {
              _pickedDate = DateTimeHelper().dateToDatabaseString(_date);
              _displayedDate = DateTimeHelper().dateToReadableString(_date);
              _dateController.text = _displayedDate;
            });
          }
        });
      } else {
        setState(() {
          _pickedDate = DateTimeHelper().dateToDatabaseString(_date);
          _displayedDate = DateTimeHelper().dateToReadableString(_date);
          _dateController.text = _displayedDate;
        });
      }
    });
  }

  Future _timePicker() async {
    showTimePicker(
      context: context,
      initialTime: isEditMode
          ? TimeOfDay.fromDateTime(DateTime.tryParse(editableDeadline.deadline))
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
                dict.displayWord('deadline', widget._model.settings.language),
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
            labelText:
                dict.displayWord('time', widget._model.settings.language),
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
                dict.displayWord(
                    'timeInvestment', widget._model.settings.language),
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

  Widget _buildSubmitButton(MainModel model) {
    return Container(
      child: RaisedButton(
        child: model.areDeadlinesLoading
            ? Center(child: CircularProgressIndicator())
            : Text(dict.displayWord('save', model.settings.language)),
        onPressed: () async {
          if (_formKey.currentState.validate() == false) {
            return;
          }
          _formKey.currentState.save();
          Deadline deadline = _buildDeadline();
          isEditMode
              ? await model.updateDeadline(widget._deadlineId, deadline)
              : await model.insertDeadline(deadline);
          model.getAllDeadlinesLocal(showIncompleted: true);
          model.getLocalDeadlinesByDeadline().then((_) {
            Navigator.pushReplacementNamed(context, model.activeTabRoute);
          });
        },
      ),
    );
  }

  Deadline _buildDeadline() {
    Deadline deadline = Deadline(
      name: _name,
      description: _description,
      deadline: _pickedDate,
      deadlineTime: _pickedTime,
      timeInvestment: _timeInvestment,
      priority: _prioValue,
    );
    return deadline;
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
                child: isEditMode
                    ? Text(dict.displayPhrase(
                        'editDeadline', widget._model.settings.language))
                    : Text(dict.displayPhrase(
                        'createDeadline', widget._model.settings.language)),
                margin: EdgeInsets.all(10.0),
              ),
              _buildNameField(),
              _buildDescrField(),
              _buildDeadlineRow(),
              ExpansionTile(
                title: Text(
                    dict.displayWord("more", widget._model.settings.language)),
                children: <Widget>[
                  _buildPrioBar(),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      dict.displayWord(
                          'priority', widget._model.settings.language),
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                  _buildTimeInvestmentSlider(),
                ],
              ),
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
