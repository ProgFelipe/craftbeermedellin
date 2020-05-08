import 'package:flutter/material.dart';

class DecorationConsts {
  DecorationConsts._();

  static const double cardRadius = 10.0;
  static Color hintGreyColor = Colors.grey[300];
}

RoundedRectangleBorder cardDecoration() {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(DecorationConsts.cardRadius),
  );
}
