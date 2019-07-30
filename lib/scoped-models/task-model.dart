import "dart:collection";
import 'package:scoped_model/scoped_model.dart';

import '../database/local-db.dart';
import '../models/task.dart';

mixin TaskModel on Model {
  List<Task> _tasks = [];

  // SplayTreeMap to provide a sorted Map
  SplayTreeMap<String, List<Task>> _tasksByDeadline = SplayTreeMap.from({});
  bool _areTasksLoading = false;
  int _tasksCount;

  List<Task> get tasks {
    return _tasks;
  }

  Map get tasksByDeadline {
    return _tasksByDeadline;
  }

  bool get areTasksLoading {
    return _areTasksLoading;
  }

  int get tasksCount {
    return _tasksCount;
  }

  int get differentDeadlineCount {
    return _tasksByDeadline.length;
  }

  Task taskById(String id) {
    Task task = _tasks.firstWhere((element) {
      return element.id == id;
    });
    return task;
  }

  getAllTasksLocal({bool showIncompleted, bool showCompleted}) async {
    _areTasksLoading = true;
    notifyListeners();
    _tasks = [];
    List<Map<String, dynamic>> rawTasksData = await LocalDB.db.fetchAllTasks();
    rawTasksData.forEach((task) {
      if (showIncompleted == true && task['isCompleted'] == 0) {
        _tasks.add(Task(
          id: task['id'],
          name: task["name"],
          description: task["description"],
          priority: task['priority'],
          deadline: task['deadline'],
          deadlineTime: task['deadlineTime'],
          timeInvestment: task['timeInvestment'],
          onlyScheduled: task['onlyScheduled'] == 1 ? true : false,
          isCompleted: task['isCompleted'] == 1 ? true : false,
        ));
      }
      if (showCompleted == true && task['isCompleted'] == 1) {
        _tasks.add(Task(
          id: task['id'],
          name: task["name"],
          description: task["description"],
          priority: task['priority'],
          deadline: task['deadline'],
          deadlineTime: task['deadlineTime'],
          timeInvestment: task['timeInvestment'],
          onlyScheduled: task['onlyScheduled'] == 1 ? true : false,
          isCompleted: task['isCompleted'] == 1 ? true : false,
        ));
      }
    });
    if (_tasks.length != 0) {
      _tasks.sort((Task a, Task b) {
        return b.calculatedPriority - a.calculatedPriority;
      });
    }
    _tasksCount = _tasks.length;
    _areTasksLoading = false;
    notifyListeners();
  }

  getLocalTasksByDeadline() async {
    _areTasksLoading = true;
    notifyListeners();
    _tasksByDeadline = SplayTreeMap.from({});
    List<Map<String, dynamic>> rawTasksData = await LocalDB.db.fetchAllTasks();

    rawTasksData.forEach((rawTask) {
      if (rawTask['isCompleted'] == 0) {
        if (_tasksByDeadline[rawTask["deadline"]] == null) {
          _tasksByDeadline[rawTask["deadline"]] = [];
        }

        _tasksByDeadline[rawTask["deadline"]].add(Task(
          id: rawTask['id'],
          name: rawTask["name"],
          description: rawTask["description"],
          priority: rawTask['priority'],
          deadline: rawTask['deadline'],
          deadlineTime: rawTask['deadlineTime'],
          timeInvestment: rawTask['timeInvestment'],
          onlyScheduled: rawTask['onlyScheduled'] == 1 ? true : false,
          isCompleted: false,
        ));
      }
    });

    _areTasksLoading = false;
    notifyListeners();
  }

  Future<Null> updateTask(String _taskId, Task newTask) async {
    _areTasksLoading = true;
    notifyListeners();
    await LocalDB.db.updateTask(_taskId, newTask);
    _areTasksLoading = false;

    notifyListeners();
  }

  Future<bool> insertTask(Task task) async {
    _areTasksLoading = true;
    notifyListeners();
    await LocalDB.db.insertTask(task);
    _areTasksLoading = false;
    notifyListeners();
    return true;
  }

  void deleteTaskLocal(String id) async {
    await LocalDB.db.deleteTask(id);
    _tasks.removeWhere((task) {
      return task.id == id;
    });
    _tasksCount = _tasks.length;
    notifyListeners();
  }
}
