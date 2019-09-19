import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/dictionary.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:taskminder/widgets/priority-indicator.dart';

import '../globalSettings.dart';
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
  static Settings settings = Settings();

  @override
  void initState() {
    // print(widget.blockMode);
    widget.model
        .getAllDeadlinesLocal(showIncompleted: true, showCompleted: true);
    widget.model.setActiveTab(calendar: true, deadlines: false, tasks: false);
    super.initState();
  }

  DateTimeHelper dthelper = new DateTimeHelper();

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;
  int dayOne = 1;
  List<Widget> dayTiles = [];
  List<String> _monthNames =
      dict.displayCollection('months', settings.language);

  List<Widget> _buildWeekdayHeadlines() {
    List<Widget> weekdays = [];
    List<String> dayTiles =
        dict.displayCollection('shortDays', settings.language);
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
    List<Deadline> _monthlyTasks = _tasks.where((taskelement) {
      DateTime deadline = DateTime.parse(taskelement.deadline);
      int month = deadline.month;
      return month == currentMonth;
    }).toList();
    return _monthlyTasks;
  }

  List<CalendarDay> _calendarDays() {
    List<Deadline> _monthlyTasks = _getTasksOfCurrentMonth();
    List<CalendarDay> _dayTilesData = [];
    for (var i = 0; i < lastDayOfMonth(); i++) {
      _dayTilesData.add(CalendarDay(day: i + 1));
    }

    _monthlyTasks.forEach((task) {
      int day = DateTime.parse(task.deadline).day;
      if (currentYear == DateTime.now().year) {
        _dayTilesData[day - 1].hasTasks = true;
        _dayTilesData[day - 1].tasks.add(task);
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

  void _buildDays() {
    setState(() {
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
                style: TextStyle(fontSize: 7),
              ),
              color: _dayElement.hasTasks
                  ? Theme.of(context).accentColor
                  : Colors.white,
              onPressed: () {
                if (_dayElement.hasTasks) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                            //width: double.maxFinite, // Dialog needs a max width, which is the max 64bit number here
                            child: ListView.builder(
                          itemCount: _dayElement.tasks.length,
                          itemBuilder: (context, index) {
                            Deadline deadline = _dayElement.tasks[index];
                            return ListTile(
                              leading: PriorityIndicator(
                                  deadline.calculatedPriority),
                              title: Text(deadline.name),
                              subtitle: Text(deadline
                                      .getFormattedDeadline()[0]
                                      .toString() +
                                  " " +
                                  dict.displayWord('days', settings.language) +
                                  ", " +
                                  deadline
                                      .getFormattedDeadline()[1]
                                      .toString() +
                                  " " +
                                  dict.displayWord('hours', settings.language) +
                                  " " +
                                  dict.displayWord(
                                      'remaining', settings.language) +
                                  "\n" +
                                  deadline.description),
                              isThreeLine: true,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/deadline/${deadline.id}",
                                );
                              },
                            );
                          },
                        )),
                      );
                    },
                  );
                } else {
                  Navigator.pushNamed(context,
                      "/deadlineCalendar/${dthelper.makeDatabaseString(_dayElement.day, currentMonth, currentYear)}");
                }
              },
            ),
          ),
        );
      });
    });
  }

  // rework!
  _changeMonth({@required int changeBy}) {
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

  @override
  Widget build(BuildContext context) {
    _buildDays();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.chevron_left),
          onPressed: () => setState(() {
            _changeMonth(changeBy: -1);
          }),
        ),
        title: GestureDetector(
          child: Text("${_monthNames[currentMonth - 1]} $currentYear"),
          onTap: () async {
            DateTime pickedDateTime = await showMonthPicker(
              firstDate: DateTime.tryParse("20000101"),
              lastDate: DateTime.tryParse("29991231"),
              initialDate: DateTime.now(),
              context: context,
            );

            String datestring = dthelper.dateToDatabaseString(pickedDateTime);
            int month = int.parse(datestring.substring(4, 6));
            int year = int.parse(datestring.substring(0, 4));
            setState(() {
              currentMonth = month;
              currentYear = year;
            });
          },
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _changeMonth(changeBy: 1);
            }),
          ),
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return widget.model.areTasksLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      widget.model.getAllDeadlinesLocal(showIncompleted: true),
                  child: GridView.count(
                    crossAxisCount: 7,
                    children: dayTiles,
                  ),
                );
        },
      ),
    );
  }
}
