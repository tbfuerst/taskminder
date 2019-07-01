import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import 'package:taskminder/helpers/date-time-helper.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/tasks-list.dart';

class DeadlinesTab extends StatefulWidget {
  final MainModel model;
  DeadlinesTab(this.model);

  _DeadlinesTabState createState() => _DeadlinesTabState();
}

class _DeadlinesTabState extends State<DeadlinesTab> {
  Dictionary dict = Dictionary();
  DateTimeHelper dthelper = DateTimeHelper();
  Settings settings = Settings();

  @override
  void initState() {
    widget.model.getLocalTasksByDeadline();
    super.initState();
  }

  String _displayDeadlineTime(deadline) {
    DateTime deadlineDateTime = DateTime.tryParse(deadline);
    DateTime today =
        DateTime.tryParse(dthelper.dateToDatabaseString(DateTime.now()));

    int differenceInDays = dthelper
        .calculateDateTimeDifference(today, deadlineDateTime, inDays: true);
    int differenceInWeeks = dthelper
        .calculateDateTimeDifference(today, deadlineDateTime, inWeeks: true);
    int moduloDays = differenceInDays % 7;

    if (differenceInDays < 0) {
      return dict.displayPhrase('deadlineMissed', settings.language);
    }
    if (differenceInDays == 0) {
      return dict.displayWord('today', settings.language);
    }
    if (differenceInDays == 1) {
      return dict.displayWord('tomorrow', settings.language);
    }
    if (differenceInDays < 7) {
      return "In $differenceInDays ${dict.displayWord('days', settings.language)}";
    }
    if (differenceInDays >= 7) {
      return "In $differenceInWeeks ${dict.displayWord('weeks', settings.language)} ${dict.displayWord('and', settings.language)} $moduloDays ${dict.displayWord('days', settings.language)}";
    }
    return "error";
  }

  _buildDeadlineTiles(MainModel model) {
    List<ExpansionTile> panelList = [];
    model.tasksByDeadline.forEach((deadline, taskList) {
      panelList.add(ExpansionTile(
        title: Text(
            "${_displayDeadlineTime(deadline)} (${taskList.length.toString()})"),
        children: [
          TasksList(
            model: model,
            tasks: taskList,
            showCompletedTasksMode: false,
            deadlineMode: true,
          )
        ],
      ));
    });
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
              child: model.areTasksLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildDeadlineTiles(model)));
    });
  }
}
