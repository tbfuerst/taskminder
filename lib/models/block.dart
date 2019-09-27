import 'package:taskminder/models/job.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Block implements Job {
  String id;
  final String name;
  final String type = JobTypeName[JobType.block];
  bool isCompleted = false;
  String deadline;

  Block({
    this.id,
    @required this.name,
    @required this.deadline,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
      "deadline": deadline,
    };
  }
}
