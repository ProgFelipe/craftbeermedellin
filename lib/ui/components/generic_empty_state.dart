import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenericEmptyState extends StatelessWidget {
  const GenericEmptyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Icon(FontAwesomeIcons.percentage, color: kWhiteColor),
        SizedBox(
          height: kMarginTopFromTitle,
        ),
        Text(
          'No Results',
          style: TextStyle(
              letterSpacing: 1.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.0),
          textAlign: TextAlign.center,
        ),
      ],
    ));
  }
}
