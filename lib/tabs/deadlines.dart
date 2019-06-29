import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/tasks-list.dart';

class DeadlinesTab extends StatefulWidget {
  final MainModel model;
  DeadlinesTab(this.model);

  _DeadlinesTabState createState() => _DeadlinesTabState();
}

class _DeadlinesTabState extends State<DeadlinesTab> {
  @override
  void initState() {
    widget.model.getLocalTasksByDeadline();
    super.initState();
  }

  /// _buildDeadlineTiles(MainModel model) {
  ///   List<ExpansionPanel> panelList = [];
  ///   model.tasksByDeadline.forEach((deadline, taskList) {
  ///     panelList.add(ExpansionPanel(
  ///       body: TasksList(tasks: taskList, model: model),
  ///       headerBuilder: (context, anybool) {
  ///         return Text(deadline);
  ///       },
  ///     ));
  ///   });
  ///   print(panelList);
  ///   return Container(
  ///       child: ExpansionPanelList(
  ///     children: panelList,
  ///   ));
  /// }

  _buildDeadlineTiles(MainModel model) {
    List<ExpansionTile> panelList = [];
    model.tasksByDeadline.forEach((deadline, taskList) {
      panelList.add(ExpansionTile(
        title: Text(deadline),
        children: <Widget>[
          TasksList(
            model: model,
            tasks: taskList,
          )
        ],
      ));
    });
    print(panelList);
    return ListView.builder(
        itemCount: panelList.length,
        itemBuilder: (context, index) {
          return panelList[index];
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RefreshIndicator(
          onRefresh: () => model.getLocalTasksByDeadline(),
          child: Container(
              child: widget.model.areTasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildDeadlineTiles(model)));
    });
  }
}
