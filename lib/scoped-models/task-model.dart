import 'package:scoped_model/scoped_model.dart';

import '../database/local-db.dart';
import '../models/task.dart';

mixin TaskModel on Model {
  List<Task> _tasks = [];
  List<Task> _tasksByDeadline = [];
  bool _areTasksLoading = false;
  int _tasksCount;

  List<Task> get tasks {
    return _tasks;
  }

  List<Task> get tasksByDeadline {
    return _tasksByDeadline;
  }

  bool get areTasksLoading {
    return _areTasksLoading;
  }

  int get tasksCount {
    return _tasksCount;
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
    await LocalDB.db.initDB();
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
    _tasksByDeadline = await LocalDB.db.fetchTasksByDeadline();
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
