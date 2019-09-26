import 'package:scoped_model/scoped_model.dart';
import '../models/task.dart';
import '../database/local-db.dart';

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
          priority: task["priority"],
          isCompleted: task['isCompleted'] == 1 ? true : false,
        ));
      }
      if (showCompleted == true && task['isCompleted'] == 1) {
        _tasks.add(Task(
          id: task['id'],
          name: task["name"],
          priority: task["priority"],
          isCompleted: task['isCompleted'] == 1 ? true : false,
        ));
      }
    });
    if (_tasks.length != 0) {
      _tasks.sort((Task a, Task b) {
        return b.priority - a.priority;
      });
    }
    _tasksCount = _tasks.length;
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

  Future<bool> deleteTaskLocal(String id) async {
    await LocalDB.db.deleteTask(id);
    _tasks.removeWhere((task) {
      return task.id == id;
    });
    _tasksCount = _tasks.length;
    notifyListeners();
    return true;
  }

  Future<bool> taskExists(String id) async {
    List<Map<String, dynamic>> queriedTask = await LocalDB.db.checkTaskId(id);
    notifyListeners();
    if (queriedTask.isNotEmpty) return true;
    return false;
  }
}
