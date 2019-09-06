import 'package:flutter/material.dart';

import './deadline.dart';

class CalendarDay {
  int day;
  bool isToday = false;
  bool hasTasks = false;
  final List<Deadline> tasks = [];

  CalendarDay({@required this.day});
}
