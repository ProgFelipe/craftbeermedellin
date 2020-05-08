import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

Widget titleView(String title,
    {Color color = kWhiteColor, double size = 15.0}) {
  return Container(
    //color: Colors.greenAccent,
    width: double.infinity,
    child: Text(
      title,
      style: TextStyle(fontSize: size, color: color, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    ),
  );
}
