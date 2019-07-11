import 'package:flutter/material.dart';

class CalendarTab extends StatefulWidget {
  CalendarTab({Key key}) : super(key: key);

  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  int currentDay = DateTime.now().day;
  int dayOne = 1;
  List<Widget> days = [];

  List<Widget> _buildWeekdayHeadlines() {
    List<Widget> weekdays = [];
    List<String> days = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"];
    days.forEach((day) => weekdays.add(
          Container(child: Text(day)),
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

  void _buildDays() {
    setState(() {
      int dayOne = 1;
      days = [];
      days.addAll(_buildWeekdayHeadlines());
      days.addAll(_determineWeekDayPlaceholders());
      DateTime date = new DateTime(currentYear, currentMonth + 1, 0);
      int lastDayOfMonth = date.day;
      for (var i = 0; i < lastDayOfMonth; i++) {
        days.add(
          Container(
            child: FlatButton(
              child: Text("$dayOne"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog();
                    });
              },
            ),
          ),
        );
        dayOne++;
      }
    });
  }

  // rework!
  _changeMonth({@required int changeBy}) {
    setState(() {
      if (changeBy >= 0) {
        if ((currentMonth + changeBy % 12) > 12) {
          currentMonth = (currentMonth + changeBy) % 12;
          currentYear += 1;
        } else {
          currentMonth += changeBy;
        }
      } else {
        changeBy = -changeBy;
        if ((currentMonth - changeBy % 12) <= 0) {
          currentMonth = 12 - changeBy + 1;
          currentYear -= 1;
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
        title: Text("$currentMonth-$currentYear"),
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
      body: GridView.count(
        crossAxisCount: 7,
        children: days,
      ),
    );
  }
}
