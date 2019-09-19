import 'package:taskminder/models/job.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Task implements Job {
  String id;
  final String name;
  final String type = JobTypeName[JobType.task];
  final int priority;
  bool isCompleted;

  Task({
    this.id,
    @required this.name,
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
      "priority": priority,
      "type": type,
      'isCompleted': isCompleted,
    };
  }
}
