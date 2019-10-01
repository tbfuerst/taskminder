import 'package:flutter/material.dart';

class Settings {
  String _language = "en";
  bool _firstStartup = true;
  int _blockColor = Colors.red.value;
  int _deadlineColor = Colors.tealAccent.value;
  int _dayIndicatorColor = Colors.black.value;

  String get language {
    return _language;
  }

  bool get firstStartup {
    return _firstStartup;
  }

  int get blockColor {
    return _blockColor;
  }

  int get deadlineColor {
    return _deadlineColor;
  }

  int get dayIndicatorColor {
    return _dayIndicatorColor;
  }

  changeLanguage(String languageCode) {
    _language = languageCode;
  }

  changeFirstStartup(String to) {
    if (to == "true") _firstStartup = true;
    if (to == "false") _firstStartup = false;
  }

  changeColors(
      int newBlockColor, int newDeadlineColor, int newDayIndicatorColor) {
    _blockColor = newBlockColor;
    _deadlineColor = newDeadlineColor;
    _dayIndicatorColor = newDayIndicatorColor;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'language': language,
      'firstStartup': _firstStartup ? "true" : "false",
      'blockColor': _blockColor,
      'deadlineColor': _deadlineColor,
      'dayIndicatorColor': _dayIndicatorColor,
    };
  }
}
