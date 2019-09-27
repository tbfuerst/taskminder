import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/helpers/date-time-helper.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

class MonthDisplay extends StatelessWidget {
  final int month;
  final int year;
  final Function monthChangerCallback;
  final MainModel model;
  final Dictionary dict = Dictionary();
  final DateTimeHelper dthelper = DateTimeHelper();

  MonthDisplay(this.model, {this.month, this.year, this.monthChangerCallback});

  @override
  Widget build(BuildContext context) {
    List<String> _monthNames =
        dict.displayCollection('months', model.settings.language);
    return GestureDetector(
      child: Text("${_monthNames[month - 1]} $year"),
      onTap: () {
        showMonthPicker(
          firstDate: DateTime.tryParse("20000101"),
          lastDate: DateTime.tryParse("29991231"),
          initialDate: DateTime.now(),
          context: context,
        ).then(
          (pickedDateTime) {
            if (pickedDateTime != null)
              monthChangerCallback(changeTo: pickedDateTime);
          },
        );

        ;
      },
    );
  }
}
