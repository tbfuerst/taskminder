import 'package:flutter/material.dart';
import '../scoped-models/mainmodel.dart';

class TaskEdit extends StatefulWidget {
  final MainModel model;
  TaskEdit(this.model);

  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  int currentYear = DateTime.now().year;
  Future<DateTime> _pickedDate = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Text("Aufgabe erstellen"),
                margin: EdgeInsets.all(10.0),
              ),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Beschreibung"),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Datum",
                  suffix: IconButton(
                    iconSize: 24.0,
                    alignment: Alignment.topRight,
                    icon: Icon(Icons.date_range),
                    onPressed: () => setState(() {
                          Future<DateTime> date;
                          date = showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(currentYear),
                            lastDate: DateTime(currentYear + 12),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          ).then((_) {
                            _pickedDate = date;
                            print(_pickedDate);
                          });
                          ;
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
