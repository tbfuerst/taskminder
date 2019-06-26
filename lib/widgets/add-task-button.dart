import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';

class AddTaskButton extends StatelessWidget {
  final MainModel model;
  AddTaskButton(this.model);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/taskedit');
        });
  }
}
