import 'package:craftbeer/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: 100.0,
      child: Center(
        child: Text(
          S.of(context).loading,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
