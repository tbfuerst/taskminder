import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../dictionary.dart';
import '../globalSettings.dart';
import '../scoped-models/mainmodel.dart';

import '../widgets/jobslist/jobslist-deadline.dart';

class CompletedTasksPage extends StatefulWidget {
  final MainModel model;

  CompletedTasksPage(
    this.model,
  );

  _CompletedTasksPageState createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  final Dictionary dict = Dictionary();
  final Settings settings = Settings();
  @override
  void initState() {
    widget.model.getAllDeadlinesLocal(showCompleted: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, model.activeTabRoute);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
              dict.displayPhrase('completedTasks', model.settings.language)),
        ),
        body: JobslistDeadline(
          model: widget.model,
          deadlines: widget.model.deadlines,
          showCompletedOnly: true,
        ),
      );
    });
  }
}
