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

  double previousOffset;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.model.setActiveTab(calendar: false, deadlines: true, tasks: false);
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

  void _scrollToSelectedContent(
      bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(
          isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }

  _buildDeadlineTiles(MainModel model, int index) {
    List<ExpansionTile> panelList = [];
    final GlobalKey expansionTileKey = GlobalKey();
    model.tasksByDeadline.forEach((deadline, taskList) {
      panelList.add(ExpansionTile(
        key: expansionTileKey,
        onExpansionChanged: (isExpanded) {
          if (isExpanded) previousOffset = _scrollController.offset;
          _scrollToSelectedContent(
              isExpanded, previousOffset, index, expansionTileKey);
        },
        title: Text(
            "${_displayDeadlineTime(deadline)} (${taskList.length.toString()})"),
        children: [
          Container(
            height: taskList.length.toDouble() * 100,
            child: TasksList(
              model: model,
              tasks: taskList,
              showCompletedTasksMode: false,
              deadlineMode: true,
              dense: false,
              isWithinExpanded: true,
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
        onRefresh: () => model.getLocalTasksByDeadline(),
        child: Container(
          child: model.areTasksLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: model.tasksByDeadline.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildDeadlineTiles(model, index);
                  }),
        ),
      );
    });
  }
}
