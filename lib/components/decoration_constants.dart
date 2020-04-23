import 'package:flutter/material.dart';

///Cards
///

class DecorationConsts {
  DecorationConsts._();

  static const double cardRadius = 16.0;
  static Color hintGreyColor = Colors.grey[300];
}

Widget cardTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    child: Text(
      title ?? '',
      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
      textAlign: TextAlign.left,
    ),
  );
}

RoundedRectangleBorder cardDecoration() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(DecorationConsts.cardRadius),
  );
}
