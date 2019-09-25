import 'package:flutter/material.dart';

class PriorityPicker extends StatefulWidget {
  final Function parentsPriorityChangerCallback;

  PriorityPicker(this.parentsPriorityChangerCallback);
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  int _priorityIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.values[0],
      children: <Widget>[
        Container(
          child: FlatButton(
            color: _priorityIndex == 0 ? Colors.grey[300] : Colors.white,
            onPressed: () {
              setState(() {
                _priorityIndex = 0;
                widget.parentsPriorityChangerCallback(_priorityIndex);
              });
            },
            child: Text("--"),
          ),
        ),
        Container(
          child: FlatButton(
            color: _priorityIndex == 1 ? Colors.grey[300] : Colors.white,
            onPressed: () {
              setState(() {
                _priorityIndex = 1;
                widget.parentsPriorityChangerCallback(_priorityIndex);
              });
            },
            child: Text("!"),
          ),
        ),
        Container(
          child: FlatButton(
            color: _priorityIndex == 2 ? Colors.grey[300] : Colors.white,
            onPressed: () {
              setState(() {
                _priorityIndex = 2;
                widget.parentsPriorityChangerCallback(_priorityIndex);
              });
            },
            child: Text("!!!"),
          ),
        ),
      ],
    );
  }
}
