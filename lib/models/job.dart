import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

abstract class Job {
  String id;
  final String name;

  Job({
    this.id,
    @required this.name,
  }) {
    if (id == null) {
      id = Uuid().v1();
    }
  }

  Map<String, dynamic> toMap();
}
