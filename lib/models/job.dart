import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum jobType {
  deadline,
  task,
  block,
}

/// The id will be a unique id.
/// The name has no requirements (except being String).
/// Possible types (== subclasses):
/// deadline
/// task
/// block
abstract class Job {
  String id;
  final String name;
  final type;

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
