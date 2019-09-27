import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/models/block.dart';
import 'package:taskminder/widgets/calendar/block-dialog.dart';
import 'package:taskminder/widgets/calendar/calendar-grid.dart';
import 'package:taskminder/widgets/calendar/deadline-dialog.dart';
import 'package:taskminder/widgets/calendar/month-display.dart';

import '../dictionary.dart';
import '../scoped-models/mainmodel.dart';
import '../models/calendarday.dart';
import '../models/deadline.dart';

import '../helpers/date-time-helper.dart';

class CalendarTab extends StatefulWidget {
  final MainModel model;
  final bool blockMode;

  CalendarTab(this.model, {this.blockMode});

  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  static Dictionary dict = Dictionary();

  @override
  void initState() {
    widget.model
        .getAllDeadlinesLocal(showIncompleted: true, showCompleted: true);
    widget.model.getAllBlocksLocal();
    widget.model.setActiveTab(calendar: true, deadlines: false, tasks: false);
    super.initState();
  }

  DateTimeHelper dthelper = new DateTimeHelper();

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;
  int dayOne = 1;
  List<Widget> dayTiles = [];

  List<Widget> _buildWeekdayHeadlines() {
    List<Widget> weekdays = [];
    List<String> dayTiles =
        dict.displayCollection('shortDays', widget.model.settings.language);
    dayTiles.forEach((day) => weekdays.add(
          Container(
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            alignment: Alignment.center,
          ),
        ));
    return weekdays;
  }

  List<Widget> _determineWeekDayPlaceholders() {
    final List<Widget> placeholders = [];
    DateTime date = new DateTime(currentYear, currentMonth, 1);
    for (var i = 0; i < date.weekday - 1; i++) {
      placeholders.add(Container());
    }
    return placeholders;
  }

  List<Deadline> _getTasksOfCurrentMonth() {
    List<Deadline> _tasks = widget.model.deadlines;
    List<Deadline> _monthlyDeadlines = _tasks.where((taskelement) {
      DateTime deadline = DateTime.parse(taskelement.deadline);
      int month = deadline.month;
      return month == currentMonth;
    }).toList();
    return _monthlyDeadlines;
  }

  List<Block> getBlocksOfCurrentMonth() {
    List<Block> _blocks = widget.model.blocks;
    List<Block> _monthlyBlocks = _blocks.where((block) {
      DateTime date = DateTime.parse(block.deadline);
      int month = date.month;
      return month == currentMonth;
    }).toList();
    return _monthlyBlocks;
  }

  List<CalendarDay> _calendarDays() {
    List<Deadline> _monthlyDeadlines = _getTasksOfCurrentMonth();
    List<Block> _monthlyBlocks = getBlocksOfCurrentMonth();
    List<CalendarDay> _dayTilesData = [];
    for (var i = 0; i < lastDayOfMonth(); i++) {
      _dayTilesData.add(CalendarDay(day: i + 1));
    }

    _monthlyDeadlines.forEach((deadline) {
      int day = DateTime.parse(deadline.deadline).day;
      if (currentYear == DateTime.now().year) {
        _dayTilesData[day - 1].hasDeadlines = true;
        _dayTilesData[day - 1].deadlines.add(deadline);
      }
    });

    _monthlyBlocks.forEach((block) {
      int day = DateTime.parse(block.deadline).day;
      if (currentYear == DateTime.now().year) {
        _dayTilesData[day - 1].hasBlocks = true;
        _dayTilesData[day - 1].blocks.add(block);
      }
    });

    if (currentMonth == DateTime.now().month &&
        currentYear == DateTime.now().year) {
      _dayTilesData[currentDay - 1].isToday = true;
    }

    return _dayTilesData;
  }

  int lastDayOfMonth() {
    DateTime date = new DateTime(currentYear, currentMonth + 1, 0);
    return date.day;
  }

  Future<void> _buildDays() async {
    dayTiles = [];
    dayTiles.addAll(_buildWeekdayHeadlines());
    dayTiles.addAll(_determineWeekDayPlaceholders());
    List<CalendarDay> _daysData = _calendarDays();

    _daysData.forEach((_dayElement) {
      dayTiles.add(
        Container(
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: Border.all(
                width: 2.0,
                color: _dayElement.isToday
                    ? Theme.of(context).errorColor
                    : Colors.white),
          ),
          child: FlatButton(
            child: Text(
              _dayElement.day.toString(),
              style: TextStyle(fontSize: 12),
            ),
            color: _dayElement.hasDeadlines
                ? Theme.of(context).accentColor
                : _dayElement.hasBlocks ? Colors.red : Colors.white,
            onPressed: () {
              if (_dayElement.hasDeadlines) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeadlineDialog(widget.model,
                        dayElement: _dayElement);
                  },
                );
              } else if (_dayElement.hasBlocks) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlockDialog(
                        widget.model,
                        dayElement: _dayElement,
                      );
                    });
              } else {
                Navigator.pushNamed(context,
                    "/deadlineCalendar/${dthelper.makeDatabaseString(_dayElement.day, currentMonth, currentYear)}");
              }
            },
          ),
        ),
      );
    });
  }

  _changeMonthByArrow({@required int changeBy}) {
    setState(() {
      if (changeBy >= 0) {
        if ((currentMonth + changeBy % 12) > 12) {
          currentYear += ((currentMonth + changeBy) ~/ 12);
          currentMonth = (currentMonth + changeBy) % 12;
        } else {
          currentMonth += changeBy;
        }
      } else {
        changeBy = -changeBy;
        if ((currentMonth - changeBy % 12) <= 0) {
          currentYear -= ((currentMonth - changeBy) ~/ 12) + 1;
          currentMonth = 12 - changeBy + 1;
        } else {
          currentMonth -= changeBy;
        }
      }
    });
  }

  void _monthChangerCallback({DateTime changeTo}) {
    String datestring = dthelper.dateToDatabaseString(changeTo);
    setState(() {
      currentMonth = int.parse(datestring.substring(4, 6));
      currentYear = int.parse(datestring.substring(0, 4));
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildDays();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.chevron_left),
          onPressed: () => setState(() {
            _changeMonthByArrow(changeBy: -1);
          }),
        ),
        title: MonthDisplay(
          widget.model,
          month: currentMonth,
          year: currentYear,
          monthChangerCallback: _monthChangerCallback,
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _changeMonthByArrow(changeBy: 1);
            }),
          ),
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return widget.model.areDeadlinesLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      widget.model.getAllDeadlinesLocal(showIncompleted: true),
                  child: CalendarGrid(
                    dayTiles: dayTiles,
                  ));
        },
      ),
    );
  }
}
