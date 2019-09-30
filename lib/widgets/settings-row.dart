import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:taskminder/scoped-models/mainmodel.dart';

class SettingsRow extends StatelessWidget {
  final String description;
  final Widget actionWidget;
  final EdgeInsets rowMargins =
      EdgeInsets.symmetric(horizontal: 15, vertical: 5);
  final MainAxisAlignment rowAlignment = MainAxisAlignment.spaceBetween;

  SettingsRow(this.description, this.actionWidget);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          margin: rowMargins,
          child: Row(
            mainAxisAlignment: rowAlignment,
            children: <Widget>[
              Text(description),
              actionWidget,
            ],
          ),
        );
      },
    );
  }
}
