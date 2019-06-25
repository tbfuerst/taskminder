import "package:flutter/material.dart";

class PriorityIndicator extends StatelessWidget {
  final int priority;

  const PriorityIndicator(this.priority);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Text("$priority"),
      ),
    );
  }
}
