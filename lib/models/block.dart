import 'package:taskminder/models/job.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

//TODO: write new datastructure, maybe abstract classes for simpletasks and regular tasks?

class Block implements Job {
  String id;
  final String name;
  final type = jobType.block;
  String deadline;

  Block({
    this.id,
    @required this.name,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "deadline": deadline,
    };
  }
}
