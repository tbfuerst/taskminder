import 'package:flutter/material.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/models/calendarday.dart';
import 'package:taskminder/models/deadline.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

import '../priority-indicator.dart';

class DeadlineDialog extends StatelessWidget {
  final MainModel model;
  final CalendarDay dayElement;
  final Dictionary dict = Dictionary();

  DeadlineDialog(this.model, {this.dayElement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          //width: double.maxFinite, // Dialog needs a max width, which is the max 64bit number here
          child: ListView.builder(
        itemCount: dayElement.deadlines.length,
        itemBuilder: (context, index) {
          Deadline deadline = dayElement.deadlines[index];
          return ListTile(
            leading: PriorityIndicator(deadline.calculatedPriority),
            title: Text(deadline.name),
            subtitle: Text(deadline.getFormattedDeadline()[0].toString() +
                " " +
                dict.displayWord('days', model.settings.language) +
                ", " +
                deadline.getFormattedDeadline()[1].toString() +
                " " +
                dict.displayWord('hours', model.settings.language) +
                " " +
                dict.displayWord('remaining', model.settings.language) +
                "\n" +
                deadline.description),
            isThreeLine: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                "/deadlinedetail/${deadline.id}",
              );
            },
          );
        },
      )),
    );
  }
}
