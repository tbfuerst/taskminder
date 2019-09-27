import 'package:flutter/material.dart';

class CalendarGrid extends StatelessWidget {
  final List<Widget> dayTiles;

  CalendarGrid({this.dayTiles});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: dayTiles,
    );
  }
}
