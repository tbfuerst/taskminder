import 'package:flutter/material.dart';

import './deadline.dart';
import 'block.dart';

class CalendarDay {
  int day;
  bool isToday = false;
  bool hasTasks = false;
  bool hasBlocks = false;
  final List<Deadline> tasks = [];
  final List<Block> blocks = [];

  CalendarDay({@required this.day});
}
