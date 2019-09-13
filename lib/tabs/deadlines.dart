import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/globalSettings.dart';
import 'package:taskminder/helpers/date-time-helper.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/jobslist/jobslist-deadline.dart';

class DeadlinesTab extends StatefulWidget {
  final MainModel model;
  DeadlinesTab(this.model);

  _DeadlinesTabState createState() => _DeadlinesTabState();
}

class _DeadlinesTabState extends State<DeadlinesTab> {
  Dictionary dict = Dictionary();
  DateTimeHelper dthelper = DateTimeHelper();
  Settings settings = Settings();
  Function reference;

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: true, tasks: false);
    widget.model.getLocalDeadlinesByDeadline();
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

  _buildDeadlineTiles(MainModel model, int index) {
    List<ExpansionTile> panelList = [];
    final GlobalKey expansionTileKey = GlobalKey();

    model.deadlinesByDeadline.forEach((deadline, taskList) {
      panelList.add(ExpansionTile(
        key: expansionTileKey,
        title: Text(
            "${_displayDeadlineTime(deadline)} (${taskList.length.toString()})"),
        children: [
          Container(
            height: taskList.length.toDouble() * 100,
            child: JobslistDeadline(
              model: model,
              deadlines: taskList,
              showCompletedOnly: false,
            ),
          )
        ],
      ));
    });
    return panelList[index];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return RefreshIndicator(
        onRefresh: () => model.getLocalDeadlinesByDeadline(),
        child: Container(
          child: model.areTasksLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: model.deadlinesByDeadline.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildDeadlineTiles(model, index);
                  }),
        ),
      );
    });
  }
}
