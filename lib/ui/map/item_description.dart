import 'package:flutter/material.dart';

class ItemDescription extends StatelessWidget {
  final IconData icon;
  final String description;
  final Color iconColor;
  ItemDescription({
    @required this.icon, @required this.description, this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? Colors.blue),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.0),
          ),
        )
      ],
    );
  }
}
