import 'package:flutter/material.dart';
import 'package:unicorndial/unicorndial.dart';
import '../scoped-models/mainmodel.dart';
import '../dictionary.dart';
import '../globalSettings.dart';

class AddTaskButton extends StatelessWidget {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  final MainModel model;
  AddTaskButton(this.model);

  @override
  Widget build(BuildContext context) {
    return UnicornDialer(
      hasBackground: true,
      parentButton: Icon(Icons.add),
      childButtons: <UnicornButton>[
        UnicornButton(
          hasLabel: true,
          labelText: dict.displayWord("block", model.settings.language),
          currentButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/blockedit');
            },
            mini: true,
            heroTag: "block",
            child: Icon(Icons.block),
          ),
        ),
        UnicornButton(
          hasLabel: true,
          labelText: dict.displayWord("deadline", model.settings.language),
          currentButton: FloatingActionButton(
            mini: true,
            heroTag: "deadline",
            child: Icon(Icons.calendar_today),
            onPressed: () async {
              await Navigator.pushNamed(context, '/deadlineedit');
            },
          ),
        ),
        UnicornButton(
          hasLabel: true,
          labelText: dict.displayWord("task", model.settings.language),
          currentButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.pushReplacementNamed(context, '/taskedit');
            },
            mini: true,
            heroTag: "task",
            child: Icon(Icons.short_text),
          ),
        ),
      ],
    );
  }
}
