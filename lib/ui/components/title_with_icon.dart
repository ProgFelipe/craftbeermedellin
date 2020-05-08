import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class TitleWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color titleColor;

  const TitleWithIcon({this.icon, this.title, this.titleColor});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: kWhiteColor,
        ),
        SizedBox(width: 10.0,),
        Expanded(child: titleView(title, color: titleColor)),
      ],
    );
  }
}
