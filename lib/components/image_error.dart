import 'package:flutter/material.dart';

Column errorColumn(String title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      Container(
        child: Icon(Icons.error),
      ),
    ],
  );
}