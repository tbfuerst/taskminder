import 'package:flutter/material.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/models/calendarday.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

import '../../testclass.dart';

class BlockDialog extends StatelessWidget {
  final MainModel model;
  final CalendarDay dayElement;
  final Dictionary dict = Dictionary();

  BlockDialog(this.model, {this.dayElement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(dayElement.blocks[0].name),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            TestClass test = TestClass();
            test.test();

            model.deleteBlockLocal(dayElement.blocks[0].id).then((e) {
              Navigator.pushReplacementNamed(context, model.activeTabRoute);
            });
            //await widget.model.getAllBlocksLocal();

            Navigator.pop(context);
          },
          child: Text(
            dict.displayWord('delete', model.settings.language),
          ),
        )
      ],
    );
  }
}
