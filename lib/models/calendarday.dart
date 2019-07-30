import 'package:flutter/material.dart';

import './task.dart';

class CalendarDay {
  int day;
  bool isToday = false;
  bool hasTasks = false;
  final List<Task> tasks = [];

  CalendarDay({@required this.day});
}
