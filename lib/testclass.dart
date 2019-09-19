import 'package:taskminder/models/task.dart';

import './models/job.dart';
import 'database/local-db.dart';

class TestClass {
  void test() {
    // doTest();
  }

  void doTest() {
    List<Job> jobs = [];
    Task task = Task(name: "lelelel", isCompleted: false, priority: 1);
    jobs.add(task);

    print(jobs[0].name);
  }
}
