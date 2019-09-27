import 'package:flutter/material.dart';
import 'package:taskminder/models/task.dart';
import 'package:taskminder/pages/block-edit.dart';
import 'package:taskminder/widgets/task-create-dialog.dart';
import 'package:unicorndial/unicorndial.dart';
import '../scoped-models/mainmodel.dart';
import '../dictionary.dart';
import '../globalSettings.dart';

class AddTaskButton extends StatelessWidget {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  final MainModel model;
  AddTaskButton(this.model);

  Future<bool> _addSimpleTask(BuildContext context, {taskName, priority}) {
    Task newTask = Task(
      name: taskName,
      priority: priority,
      isCompleted: false,
    );
    print(newTask.priority);
    model.insertTask(newTask).then((value) {
      Navigator.pushReplacementNamed(context, '/tasks');
    });
    return Future<bool>.value(true);
  }

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
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlockEdit(model);
                  });
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
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TaskCreateDialog(
                      model,
                      addSimpleTaskCallback: _addSimpleTask,
                    );
                  });
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
