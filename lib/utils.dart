import 'package:flutter/material.dart';

class Utils extends StatelessWidget{
  Color color;

  String title;

  double size;

  Utils(this.title, this.color, this.size);

  @override
  Widget build(BuildContext context) {
    return _buildTitle(title, color, 52.00);
  }

  Widget _buildTitle(String title, Color color, double size) {
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