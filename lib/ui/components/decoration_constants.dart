import 'package:craftbeer/ui/utils/custom_colors.dart';
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
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
    child: Text(
      title ?? '',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: kWhiteColor),
      textAlign: TextAlign.left,
    ),
  );
}

Widget cardDescription(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
    child: Text(
      title ?? '',
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: kGreenColor),
      textAlign: TextAlign.left,
    ),
  );
}

RoundedRectangleBorder cardDecoration() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(DecorationConsts.cardRadius),
  );
}
