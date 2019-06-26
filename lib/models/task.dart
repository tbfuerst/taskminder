import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'dart:math';

class Task {
  String id;
  final String name;
  final String description;
  final int priority;
  String deadline;
  final bool onlyScheduled;

  double get timeToDeadline {
    DateTime now = DateTime.now();
    DateTime dateDeadline = DateTime.tryParse(deadline);
    return dateDeadline.difference(now).inHours / 24;
  }

  int get calculatedPriority {
    int dlPriority = deadlinePriority;
    return max<int>(dlPriority, priority);
  }

  Task(
      {this.id,
      @required this.name,
      @required this.description,
      @required this.priority,
      @required this.deadline,
      @required this.onlyScheduled}) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  int get deadlinePriority {
    DateTime now = DateTime.now();
    DateTime dateDeadline = DateTime.tryParse(deadline);
    double timeToDeadline = dateDeadline.difference(now).inHours / 24;
    if (timeToDeadline < 0.8) {
      return 10;
    } else if (timeToDeadline < 21) {
      double deadlinePriority =
          [(6 / timeToDeadline * 4 + 1), 10.0].reduce(min);
      return ((deadlinePriority + priority) / 2).round();
    } else {
      return priority;
    }
  }

  List<int> getFormattedDeadline() {
    int daysToDeadline = timeToDeadline.toInt();
    int hoursToDeadline =
        ((timeToDeadline - daysToDeadline.toDouble()) * 24).round();
    return [daysToDeadline, hoursToDeadline];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "priority": priority,
      "deadline": deadline,
      "onlyScheduled": onlyScheduled,
    };
  }
}
