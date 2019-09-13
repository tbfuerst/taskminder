import 'package:taskminder/models/task.dart';

import './models/job.dart';

class TestClass {
  void test() {
    // doTest();
  }

  void doTest() {
    List<Job> jobs = [];
    Task task =
        Task(name: "lelelel", description: "dererereer", isCompleted: false);
    jobs.add(task);

    print(jobs[0].name);
  }
}
