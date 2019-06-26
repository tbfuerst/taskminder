import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';
import '../helpers/date-time-helper.dart';
import '../models/task.dart';

class TaskEdit extends StatefulWidget {
  TaskEdit.create();
  TaskEdit.edit(id) {
    final String _taskId = id;
  }

  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _dateController = TextEditingController();

  // Form Data
  String _name;
  String _description;
  String _pickedDate =
      DateTimeHelper().datetimeToDatabaseString(DateTime.now());
  int get priority {
    return (_sliderPriority / 10).round();
  }

  bool _cbIsScheduled = false;

  int currentYear = DateTime.now().year;

  String _displayedDate =
      DateTimeHelper().datetimeToReadableString(DateTime.now());
  double _sliderPriority = 50;

  String _textPrio;
  String _calculateTextPrio() {
    if (_sliderPriority < 15) {
      return "very low";
    } else if (_sliderPriority < 40) {
      return "low";
    } else if (_sliderPriority < 60) {
      return "standard";
    } else if (_sliderPriority < 85) {
      return "high";
    } else {
      return "very high";
    }
  }

  @override
  initState() {
    _textPrio = _calculateTextPrio();
    super.initState();
  }

  _buildNameField() {
    return TextFormField(
      onSaved: (String value) {
        _name = value;
      },
      validator: (String value) {
        if (value.length == 0) {
          return "Die Aufgabe braucht einen Namen";
        }
      },
      autofocus: true,
      decoration: InputDecoration(labelText: "Name"),
    );
  }

  _buildDescrField() {
    return TextFormField(
      onSaved: (String value) {
        _description = value;
      },
      decoration: InputDecoration(labelText: "Beschreibung"),
      validator: (String value) {
        if (value.length > 128) {
          return "Drücke dich treffender aus! Maximal 128 Zeichen.";
        }
      },
    );
  }

  _datePicker() async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
        _pickedDate = DateTimeHelper().datetimeToDatabaseString(_date);
        _displayedDate = DateTimeHelper().datetimeToReadableString(_date);
        _dateController.text = _displayedDate;
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
            labelText: "Datum",
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySlider() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Priorität",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(
                flex: 4,
                child: Slider(
                  value: _sliderPriority,
                  onChanged: (newValue) {
                    setState(() {
                      _sliderPriority = newValue;
                      _textPrio = _calculateTextPrio();
                    });
                  },
                  min: 0,
                  max: 100,
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(_textPrio),
              ),
            ])
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
        child: Text("Speichern"),
        onPressed: () async {
          if (_formKey.currentState.validate() == false) {
            return;
          }
          _formKey.currentState.save();
          Task task = _buildTask();
          await model.insertTask(task);
          await model.getAllTasksLocal();
          Navigator.pop(context);
        },
      ),
    );
  }

  Task _buildTask() {
    Task task = Task(
      name: _name,
      description: _description,
      deadline: _pickedDate,
      priority: priority,
      onlyScheduled: _cbIsScheduled,
    );
    return task;
  }

  @override
  Widget build(BuildContext context) {
    _dateController.text = _displayedDate;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Text("Aufgabe erstellen"),
                margin: EdgeInsets.all(10.0),
              ),
              _buildNameField(),
              _buildDescrField(),
              _buildDateField(),
              _buildPrioritySlider(),
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
