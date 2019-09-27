import "package:flutter/material.dart";

class PriorityIndicator extends StatelessWidget {
  final int priority;

  const PriorityIndicator(this.priority);

  // TODO 2: Rework priority indicator

  Color _determinePrioColor() {
    if (priority < 2) {
      return Colors.blueGrey;
    } else if (priority < 6) {
      return Colors.yellowAccent;
    } else if (priority < 9) {
      return Colors.orangeAccent;
    } else if (priority < 10) {
      return Colors.redAccent;
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(backgroundColor: _determinePrioColor()),
    );
  }
}
