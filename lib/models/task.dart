import 'package:taskminder/models/job.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

//TODO: 6) implement priority?

class Task implements Job {
  String id;
  final String name;
  final type = jobType.task;
  final String description;
  bool isCompleted;

  Task({
    this.id,
    @required this.name,
    @required this.description,
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
      'isCompleted': isCompleted,
    };
  }
}
