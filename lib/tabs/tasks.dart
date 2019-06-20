import 'package:flutter/material.dart';

import '../database/db-connection.dart';

class TasksTab extends StatefulWidget {
  TasksTab({Key key}) : super(key: key);

  _TasksTabState createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  List<Map<String, dynamic>> _taskdata;

  @override
  void initState() {
    super.initState();

    DBConnection.db.initDB().then(
          (f) => DBConnection.db.fetchAllData().then((data) {
                _taskdata = data;
                print(_taskdata);
              }),
        );
  }

  _getItemCount() async {
    await DBConnection.db.initDB();
    return _taskdata.length;
  }

  _buildListTiles(BuildContext context, int index) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _getItemCount(),
        itemBuilder: (context, index) => _buildListTiles(context, index),
      ),
    );
  }
}
