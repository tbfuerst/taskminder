import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum JobType {
  deadline,
  task,
  block,
}

const Map<JobType, String> JobTypeName = {
  JobType.deadline: "deadline",
  JobType.task: "task",
  JobType.block: "block",
};

/// The id will be a unique id.
/// The name has no requirements (except being String).
/// Possible types (== subclasses):
/// deadline
/// task
/// block
abstract class Job {
  String id;
  final String name;
  final String type;

  Job({
    @required this.name,
    @required this.type,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  Map<String, dynamic> toMap();
}
