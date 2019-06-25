import 'package:scoped_model/scoped_model.dart';

import '../database/local-db.dart';
import '../models/task.dart';

mixin TaskModel on Model {
  List<Task> _tasks = [];
  bool _areTasksLoading = false;
  int _tasksCount;

  List<Task> get tasks {
    return _tasks;
  }

  bool get areTasksLoading {
    return _areTasksLoading;
  }

  int get tasksCount {
    return _tasksCount;
  }

  getAllTasksLocal() async {
    _areTasksLoading = true;
    notifyListeners();
    _tasks = [];
    await LocalDB.db.initDB();
    List<Map<String, dynamic>> rawTasksData = await LocalDB.db.fetchAllTasks();
    rawTasksData.forEach((task) {
      _tasks.add(Task(
        id: task['id'],
        name: task["name"],
        description: task["description"],
        priority: task['priority'],
        deadline: task['deadline'],
        onlyScheduled: task['onlyScheduled'] == 1 ? true : false,
      ));
    });
    _tasksCount = _tasks.length;
    _areTasksLoading = false;
    notifyListeners();
  }

  void insertDummy() async {
    await LocalDB.db.insertDummyTask();
    notifyListeners();
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
