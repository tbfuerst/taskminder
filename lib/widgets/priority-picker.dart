import 'package:flutter/material.dart';

class PriorityPicker extends StatefulWidget {
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  Color borderColor = Colors.grey;
  double outerBorderWidth = 1.2;

  Border _bottomBorder() {
    Border(
      bottom: BorderSide(
        width: outerBorderWidth - 0.4,
        color: borderColor,
      ),
    );
  }

  Border _topBorder() {
    return Border(
      top: BorderSide(
        width: outerBorderWidth - 0.4,
        color: borderColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(
        Size(20, 57),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: outerBorderWidth),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  // color: Colors.blueGrey,
                  ),
              child: InkWell(
                onTap: () {
                  print("-");
                },
                child: Container(
                  child: Text("-"),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: _topBorder(),
              ),
              child: InkWell(
                onTap: () {
                  print("!");
                },
                child: Text("!"),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                border: _topBorder(),
              ),
              child: InkWell(
                onTap: () {
                  print("!!!");
                },
                child: Text(
                  "!!!",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
