import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

Widget titleView(String title,
    {Color color = kWhiteColor,
    double size = 20.0, EdgeInsets margin = EdgeInsets.zero}) {
  return Container(
    alignment: Alignment.topLeft,
    margin: margin,
    child: Text(
      title,
      style: TextStyle(fontFamily: 'FellGreat',fontSize: size, color: color, fontWeight: FontWeight.bold),
    ),
  );
}
