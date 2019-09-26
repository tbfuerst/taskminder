import 'package:flutter/material.dart';

import './deadline.dart';
import 'block.dart';

class CalendarDay {
  int day;
  bool isToday = false;
  bool hasDeadlines = false;
  bool hasBlocks = false;
  final List<Deadline> deadlines = [];
  final List<Block> blocks = [];

  CalendarDay({@required this.day});
}
