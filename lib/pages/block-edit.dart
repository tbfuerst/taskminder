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
  var mode;
  List<Block> dbBlocks;
  bool cbMultiDate = false;
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
    List<Block> _blocks = [];
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
    assert(timeDifference >= 0);

    int blockDays = timeDifference + 1;
    // print(blockDays);
    for (var i = 0; i < blockDays; i++) {
      DateTime _date = firstDate.add(
        Duration(days: i),
      );
      String _databaseDate = DateTimeHelper().dateToDatabaseString(_date);
      _blocks.add(Block(name: _name, deadline: _databaseDate));
    }
    _blocks.forEach((block) {
      // print(block.deadline);
    });

    return _blocks;
  }

  Future<Map<String, dynamic>> _validateBlocks(
      MainModel model, List<Block> blocks) async {
    await model.getAllBlocksLocal();
    dbBlocks = model.blocks;
    print(dbBlocks);
    List<Block> removedBlocks = [];
    List<Block> doubleBlocks = [];
    List<Block> filteredBlocks = blocks.where((block) {
      bool isNewInDB = true;
      dbBlocks.forEach((dbBlock) {
        if (dbBlock.deadline == block.deadline) {
          isNewInDB = false;
          removedBlocks.add(block);
          doubleBlocks.add(dbBlock);
        }
      });
      return isNewInDB;
    }).toList();
    print("Filtered:");
    filteredBlocks.forEach((block) => print(block.deadline));
    print("Removed:");
    removedBlocks.forEach((block) => print(block.deadline));
    print("Double:");
    doubleBlocks.forEach((block) => print(block.name));

    if (removedBlocks.isNotEmpty) {
      await showDialog(
          context: context,
          builder: (context) {
            mode = "abort";
            List<TableRow> _tableRows = [];
            _tableRows.add(
              TableRow(
                children: [
                  Text("Date"),
                  Text("New"),
                  Text("Old"),
                ],
              ),
            );
            int indexCount = 0;
            removedBlocks.forEach((removedBlock) {
              _tableRows.add(
                TableRow(
                  children: [
                    Text(DateTimeHelper()
                        .databaseDateStringToReadable(removedBlock.deadline)),
                    Text(removedBlock.name),
                    Text(doubleBlocks[indexCount].name)
                  ],
                ),
              );
              indexCount++;
            });
            return AlertDialog(
              title: Text("Overwrite existing Blocks?"),
              content: Table(
                children: _tableRows,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Save New"),
                  onPressed: () {
                    setState(() {
                      mode = "overwrite";
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  child: Text("Keep Old"),
                  onPressed: () {
                    setState(() {
                      mode = "keepOld";
                      Navigator.pop(context);
                    });
                  },
                ),
                FlatButton(
                  child: Text("Combine Names"),
                  onPressed: () {
                    setState(() {
                      mode = "combine";
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          });
    }

    return {
      'filteredBlocks': filteredBlocks,
      'removedBlocksNew': removedBlocks,
      'doubleBlocksOld': doubleBlocks,
      'mode': mode,
    };
  }

  _saveBlocks(MainModel model, Map<String, dynamic> validatedBlocks) async {
    /// KeepOld mode:
    /// only save the blocks which are unique
    ///
    /// Overwrite mode
    /// update the blocks which arent unique with the new name
    ///
    /// Combine mode
    /// Combine the 2 names of the non unique block into one unique block
    ///

    if (mode == "abort") return;
    List<Block> _blocksToSave = validatedBlocks['filteredBlocks'];
    List<Block> _blocksToUpdate = [];

    if (validatedBlocks['mode'] == "combine") {
      int indexCount = 0;
      validatedBlocks['removedBlocksNew'].forEach((newBlock) {
        Block combinedBlock = Block(
          deadline: newBlock.deadline,
          name: newBlock.name +
              "+" +
              validatedBlocks['doubleBlocksOld'][indexCount].name,
        );
        _blocksToUpdate.add(combinedBlock);
        indexCount++;
      });
    }
    if (validatedBlocks['mode'] == "overwrite") {
      _blocksToSave = validatedBlocks['filteredBlocks'];
      _blocksToUpdate = validatedBlocks['removedBlocksNew'];
    }

    _blocksToSave.forEach((block) async => await model.insertBlock(block));
    _blocksToUpdate.forEach(
        (block) async => await model.updateBlock(block.deadline, block));
  }

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
                        dict.displayWord('addBlock', model.settings.language)),
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
                  cbMultiDate
                      ? Container(
                          child: _buildDateField(model, isSecond: true),
                        )
                      : Container(),
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
                        setState(() {
                          _name = name;
                        });
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                        "${dict.displayWord('blockImperative', model.settings.language)} $numberOfDays ${dayWord(model)}"),
                    onPressed: () async {
                      if (_formKey.currentState.validate() == false) {
                        return;
                      }
                      _formKey.currentState.save();
                      List<Block> _blocks = _createBlocks();
                      Map<String, dynamic> _validatedBlocks =
                          await _validateBlocks(model, _blocks);
                      await _saveBlocks(model, _validatedBlocks);
                      print("add to database");
                      Navigator.pop(context);
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
