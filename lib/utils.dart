import 'package:flutter/material.dart';

Widget titleView(String title,
    {Color color = Colors.white, double size = 30.0, double padding = 20.0}) {
  return Container(
    width: double.infinity,
    child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          title,
          style: TextStyle(fontSize: size, color: color),
          textAlign: TextAlign.left,
        )),
  );
}
