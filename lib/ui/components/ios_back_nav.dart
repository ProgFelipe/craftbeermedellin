import 'dart:io';

import 'package:flutter/material.dart';

class IosBackNav extends StatelessWidget {
  final Function onBack;
  final Color color;

  IosBackNav({this.onBack, this.color});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
              onTap: () {
                if (onBack != null) {
                  onBack();
                }
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 40.0,
                color: color ?? Colors.white,
              ),
            )
        : SizedBox();
  }
}
