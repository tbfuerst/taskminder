import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';
import 'package:taskminder/widgets/settings-row.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class SettingsPage extends StatefulWidget {
  final MainModel model;

  SettingsPage(this.model);
  _SettingsPageState createState() => _SettingsPageState();
}

//TODO 2: add database connection for persistence

class _SettingsPageState extends State<SettingsPage> {
  Dictionary dict = Dictionary();
  String chosenLanguageCode;
  String languageWord;
  Color blockColor = Colors.purple;
  Color deadlineColor = Colors.tealAccent;
  Color dayIndicatorColor = Colors.black;
  List<String> languageWords = [
    'English',
    'Deutsch',
  ];

  int get blockColorRGB {
    return blockColor.value;
  }

  int get deadlineColorRGB {
    return deadlineColor.value;
  }

  int get dayIndicatorColorRGB {
    return dayIndicatorColor.value;
  }

  String getLanguageWord(String languageCode) {
    switch (languageCode) {
      case "en":
        return "English";

        break;

      case "de":
        return "Deutsch";
        break;
      default:
    }
  }

  @override
  void initState() {
    chosenLanguageCode = widget.model.settings.language;
    languageWord = getLanguageWord(chosenLanguageCode);
    blockColor = Color(widget.model.settings.blockColor);
    deadlineColor = Color(widget.model.settings.deadlineColor);
    dayIndicatorColor = Color(widget.model.settings.dayIndicatorColor);
    super.initState();
  }

  _languageSelector(MainModel model) {
    return DropdownButton<String>(
      value: languageWord,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          languageWord = newValue;
          switch (newValue) {
            case 'English':
              chosenLanguageCode = "en";
              break;
            case 'Deutsch':
              chosenLanguageCode = "de";
              break;
            default:
              chosenLanguageCode = "en";
          }
        });
      },
      items: languageWords.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void changeBlockColor(Color toColor) {
    blockColor = toColor;
  }

  void changeDeadlineColor(Color toColor) {
    deadlineColor = toColor;
  }

  void changeDayIndicatorColor(Color toColor) {
    dayIndicatorColor = toColor;
  }

  Widget _colorSelector(Color initialColor, Function colorChangeFunction) {
    return RaisedButton(
      child: Row(
        children: <Widget>[
          Text("Change"),
          SizedBox(
            width: 10,
          ),
          Container(
            child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: initialColor,
            ),
          ),
        ],
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: MaterialColorPicker(
                allowShades: false,
                selectedColor: initialColor,
                onMainColorChange: (Color color) {
                  setState(() {
                    colorChangeFunction(color);
                    print("Block: $blockColor");
                    print("Deadline: $deadlineColor");
                    print("DayIndicator: $dayIndicatorColor");
                    Navigator.pop(context);
                  });

                  //Navigator.pop(context);
                },
                shrinkWrap: true,
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _saveToDatabase(MainModel model) async {
    Settings settings = Settings();
    settings.changeLanguage(chosenLanguageCode);
    settings.changeFirstStartup('false');
    settings.changeColors(
        blockColorRGB, deadlineColorRGB, dayIndicatorColorRGB);

    return await model.updateSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        dict.displayPhrase(
                            'saveChanges', model.settings.language),
                      ),
                      content: Text(
                        dict.displayPhrase(
                            'savePromptLong', model.settings.language),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            dict.displayWord('cancel', model.settings.language),
                          ),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, model.activeTabRoute),
                          child: Text(
                            dict.displayWord(
                                'discard', model.settings.language),
                          ),
                        ),
                        FlatButton(
                          onPressed: () => _saveToDatabase(model).then((e) =>
                              Navigator.pushReplacementNamed(
                                  context, model.activeTabRoute)),
                          child: Text(
                            dict.displayWord('save', model.settings.language),
                          ),
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(dict.displayWord('settings', model.settings.language)),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                dict.displayWord('settings', model.settings.language),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            SettingsRow(
              dict.displayWord('language', model.settings.language),
              _languageSelector(model),
            ),
            SettingsRow(
              dict.displayWord('blockColor', model.settings.language),
              _colorSelector(blockColor, changeBlockColor),
            ),
            SettingsRow(
              dict.displayWord('deadlineColor', model.settings.language),
              _colorSelector(deadlineColor, changeDeadlineColor),
            ),
            SettingsRow(
              dict.displayWord('todayColor', model.settings.language),
              _colorSelector(dayIndicatorColor, changeDayIndicatorColor),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: RaisedButton(
                onPressed: () => _saveToDatabase(model).then((e) =>
                    Navigator.pushReplacementNamed(
                        context, model.activeTabRoute)),
                child: Text(
                  dict.displayWord('save', model.settings.language),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
