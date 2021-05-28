import 'package:flutter/material.dart';

class Train extends StatelessWidget {
  final bool isVertical;
  const Train({Key key, this.isVertical = false}) : super(key: key);
  static const double _height = 20;
  static const double _width = 200;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        height: isVertical ? _width : _height,
        width: isVertical ? _height : _width,
        color: Colors.grey);
  }
}
