import 'package:uuid/uuid.dart';

class Task {
  final String id = Uuid().v1();
  final String name;
  final String description;
  final int priority;
  final String deadline;

  Task({this.name, this.description, this.priority, this.deadline});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "priority": priority,
      "deadline": deadline
    };
  }
}
