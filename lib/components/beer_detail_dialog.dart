import 'package:flutter/material.dart';

class BeerDetailDialog extends StatelessWidget {
  final String title, description, buttonText, actionText;
  final String contentImage;
  final Color avatarColor;
  final String avatarImage;
  final VoidCallback action;
  final bool starts;
  BeerDetailDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.contentImage,
    this.avatarColor,
    this.avatarImage,
    this.actionText,
    this.action,
    this.starts = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Consts.avatarRadius + Consts.padding,
              bottom: Consts.padding,
              left: Consts.padding,
              right: Consts.padding,
            ),
            margin: EdgeInsets.only(top: Consts.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Consts.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Visibility(
                  visible: starts,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/icon.png',
                        height: 70.0,
                      ),
                      Image.asset(
                        'assets/icon.png',
                        height: 70.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: actionText != null,
                      child: FlatButton(
                        onPressed: () {
                          action(); // To close the dialog
                        },
                        child: actionText != null ? Text(actionText) : Text(''),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: avatarImage != null
                ? CircleAvatar(
                    child: Image.network(avatarImage),
                    backgroundColor: avatarColor,
                    radius: Consts.avatarRadius,
                  )
                : CircleAvatar(
                    child: Image.network(contentImage),
                    backgroundColor: Colors.blueAccent,
                    radius: Consts.avatarRadius,
                  ),
          ),
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
