import 'package:flutter/material.dart';
import 'package:taskminder/dictionary.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

class BlockedDeadlineDialog extends StatelessWidget {
  final Dictionary dict = Dictionary();
  final MainModel model;
  final DateTime pickedDate;

  BlockedDeadlineDialog(this.model, {this.pickedDate});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      children: [
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Text(
                dict.displayPhrase('dateIsBlocked', model.settings.language),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 40),
              child: Text(
                dict.displayPhrase(
                    'deleteBlockOrChangeDeadline', model.settings.language),
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                String id = await model.getBlockIDByDate(pickedDate);
                await model.deleteBlockLocal(id);
                Navigator.pop(context, true);
              },
              child: Text(
                dict.displayPhrase('deleteBlock', model.settings.language),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                dict.displayPhrase('changeDate', model.settings.language),
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).accentColor),
              ),
            ),
          ],
        )
      ],
    );
  }
}
