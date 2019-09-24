import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/models/block.dart';
import '../scoped-models/mainmodel.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/helpers/date-time-helper.dart';

class BlockEdit extends StatefulWidget {
  _BlockEditState createState() => _BlockEditState();
}

class _BlockEditState extends State<BlockEdit> {
  bool cbMultiDate = false;
  int _numberOfDays = 1;
  Dictionary dict = Dictionary();
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  String _name;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _nameControllerFirstTap = false;
  TextEditingController _nameController = TextEditingController(text: "Reason");
  TextEditingController _dateControllerFirst = TextEditingController(
      text: DateTimeHelper().dateToReadableString(DateTime.now()));

  String _pickedDateFirst =
      DateTimeHelper().dateToDatabaseString(DateTime.now());
  String _displayedDateFirst =
      DateTimeHelper().dateToReadableString(DateTime.now());
  TextEditingController _dateControllerSecond = TextEditingController(
      text: DateTimeHelper().dateToReadableString(DateTime.now()));
  String _pickedDateSecond =
      DateTimeHelper().dateToDatabaseString(DateTime.now());
  String _displayedDateSecond =
      DateTimeHelper().dateToReadableString(DateTime.now());

  int get numberOfDays {
    DateTime firstDate = DateTime.tryParse(_pickedDateFirst);
    DateTime secondDate = DateTime.tryParse(_pickedDateSecond);
    return (firstDate.difference(secondDate).inDays).abs() + 1;
  }

  String dayWord(MainModel model) {
    if (numberOfDays > 1)
      return dict.displayWord('days', model.settings.language);
    else
      return dict.displayWord('day', model.settings.language);
  }

  Future _datePicker(bool isSecond) async {
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
        if (cbMultiDate) {
          if (isSecond) {
            _pickedDateSecond = DateTimeHelper().dateToDatabaseString(_date);
            _displayedDateSecond = DateTimeHelper().dateToReadableString(_date);
            _dateControllerSecond.text = _displayedDateSecond;
          } else {
            _pickedDateFirst = DateTimeHelper().dateToDatabaseString(_date);
            _displayedDateFirst = DateTimeHelper().dateToReadableString(_date);
            _dateControllerFirst.text = _displayedDateFirst;
          }
        } else {
          _pickedDateSecond = DateTimeHelper().dateToDatabaseString(_date);
          _displayedDateSecond = DateTimeHelper().dateToReadableString(_date);
          _dateControllerSecond.text = _displayedDateSecond;
          _pickedDateFirst = DateTimeHelper().dateToDatabaseString(_date);
          _displayedDateFirst = DateTimeHelper().dateToReadableString(_date);
          _dateControllerFirst.text = _displayedDateFirst;
        }
      });
    });
  }

  Widget _buildDateField(MainModel model, {bool isSecond}) {
    return GestureDetector(
      onTap: () {
        _datePicker(isSecond);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: isSecond ? _dateControllerSecond : _dateControllerFirst,
          decoration: InputDecoration(
            labelText: cbMultiDate
                ? isSecond
                    ? dict.displayWord('to', model.settings.language)
                    : dict.displayWord('from', model.settings.language)
                : dict.displayWord('date', model.settings.language),
          ),
        ),
      ),
    );
  }

  List<Block> _createBlocks() {
    List<Block> _blocks;
    DateTime firstDate = DateTime.tryParse(_pickedDateFirst);
    DateTime secondDate = DateTime.tryParse(_pickedDateSecond);
    int timeDifference;

    if (firstDate.isAfter(secondDate)) {
      DateTime buffer = secondDate;
      buffer = firstDate;
      firstDate = secondDate;
      secondDate = buffer;
    }

    timeDifference = secondDate.difference(firstDate).inDays;
    print(timeDifference);
    assert(timeDifference >= 0);
    for (var i = 0; i < timeDifference; i++) {
      DateTime _date = firstDate.add(
        Duration(days: i),
      );
      String _databaseDate = DateTimeHelper().dateToDatabaseString(_date);
      _blocks.add(Block(name: _name, deadline: _databaseDate));
    }
    print(_blocks);
    return _blocks;
  }

  _saveBlocks(List<Block> blocks) {}

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Dialog(
          child: Card(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Text(
                        dict.displayWord('addBlocks', model.settings.language)),
                  ),
                  Container(
                    child: _buildDateField(model, isSecond: false),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: cbMultiDate,
                          onChanged: (changedValue) {
                            setState(() {
                              if (changedValue == false) {
                                _pickedDateSecond = _pickedDateFirst;
                                _displayedDateSecond = _displayedDateFirst;
                              }
                              cbMultiDate = changedValue;
                            });
                          },
                        ),
                        Container(
                          child: Text(dict.displayPhrase(
                              'blockMorePrompt', model.settings.language)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: _nameController,
                      onTap: () {
                        setState(() {
                          if (_nameControllerFirstTap == false)
                            _nameController.text = "";
                          _nameControllerFirstTap = true;
                        });
                      },
                      onSaved: (name) {
                        _name = name;
                      },
                    ),
                  ),
                  cbMultiDate
                      ? Container(
                          child: _buildDateField(model, isSecond: true),
                        )
                      : Container(),
                  RaisedButton(
                    child: Text("Block $numberOfDays ${dayWord(model)}"),
                    onPressed: () {
                      if (_formKey.currentState.validate() == false) {
                        return;
                      }
                      _formKey.currentState.save();
                      List<Block> _blocks = _createBlocks();
                      _saveBlocks(_blocks);
                      print("add to database");
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
