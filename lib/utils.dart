import 'package:flutter/material.dart';

class TitleTextUtils extends StatelessWidget{
  Color color;

  String title;

  double size;

  TitleTextUtils(this.title, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return _buildTitle(title, color, size: 52.00);
  }

  Widget _buildTitle(String title, Color color, {double size = 50.0}) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          title,
          style: TextStyle(
              fontFamily: 'Blessed', fontSize: size, color: color),
          textAlign: TextAlign.left,
        ));
  }
}