import 'package:taskminder/database/local-db.dart';

class TestClass {
  void test() {
    // doTest();
  }

  void doTest() {
    LocalDB.db.fetchAllJobs().then((result) {
      print(result['blocks'][0]['id']);
    });
  }
}
