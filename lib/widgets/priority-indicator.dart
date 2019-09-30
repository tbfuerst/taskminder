import "package:flutter/material.dart";

class PriorityIndicator extends StatelessWidget {
  final int priority;

  const PriorityIndicator(this.priority);

  Color _determinePrioColor() {
    switch (priority) {
      case 0:
        return Colors.blueGrey;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.redAccent;
        break;
      default:
        return Colors.blueGrey;
    }
  }

  Color _determineTextColor() {
    if (priority == 0)
      return Colors.white;
    else
      return Colors.black;
  }

  String _determinePrioText() {
    switch (priority) {
      case 0:
        return "--";
      case 1:
        return "!";
      case 2:
        return "!!!";
        break;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        backgroundColor: _determinePrioColor(),
        child: Text(
          _determinePrioText(),
          style: TextStyle(
            color: _determineTextColor(),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
