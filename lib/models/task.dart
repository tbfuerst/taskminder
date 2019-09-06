import 'package:taskminder/models/job.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

import 'dart:math';

//TODO: write new datastructure, maybe abstract classes for simpletasks and regular tasks?

class Task implements Job {
  String id;
  final String name;
  final type = jobType.task;
  final String description;
  final int priority;
  bool isCompleted;

  Task({
    this.id,
    @required this.name,
    @required this.description,
    @required this.priority,
    this.isCompleted,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
    if (isCompleted == null) {
      isCompleted = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "priority": priority,
      'isCompleted': isCompleted,
    };
  }
}
