import 'package:flutter/material.dart';

typedef IntCallback = Function(int num);

class BeerDetailDialog extends StatefulWidget {
  final String title, description, buttonText, actionText;
  final String contentImage;
  final Color avatarColor;
  final String avatarImage;
  final VoidCallback action;
  final IntCallback voteAction;
  final bool starts, showVotesBox;

  BeerDetailDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.contentImage,
    this.avatarColor,
    this.avatarImage,
    this.actionText,
    this.showVotesBox = false,
    this.voteAction,
    this.action,
    this.starts = false,
  });

  @override
  _BeerDetailDialogState createState() => _BeerDetailDialogState(
        title: title,
        description: description,
        buttonText: buttonText,
        contentImage: contentImage,
        avatarColor: avatarColor,
        avatarImage: avatarImage,
        actionText: actionText,
        showVotesBox: showVotesBox,
        voteAction: voteAction,
        action: action,
        starts: starts,
      );
}

class _BeerDetailDialogState extends State<BeerDetailDialog> {
  final String title, description, buttonText, actionText;
  final String contentImage;
  final Color avatarColor;
  final String avatarImage;
  final VoidCallback action;
  final IntCallback voteAction;
  final bool starts, showVotesBox;

  _BeerDetailDialogState({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.contentImage,
    this.avatarColor,
    this.avatarImage,
    this.actionText,
    this.showVotesBox = false,
    this.voteAction,
    this.action,
    this.starts = false,
  });

  bool _canVote = true;
  void onVote(int vote) {
    setState(() {
      _canVote = false;
    });
    voteAction(vote);
  }

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
                SizedBox(
                  height: 15.0,
                ),
                Visibility(
                  visible: showVotesBox && _canVote,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Que tanto te gustó?',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: Iterable<Widget>.generate(
                            5,
                            (index) => VoteItem(
                                  index: index,
                                  voteAction: onVote,
                                )).toList(),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: showVotesBox && !_canVote,
                  child: Text(
                    'Gracias por votar!',
                    style: TextStyle(color: Colors.amberAccent),
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
                          Navigator.of(context).pop();
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
            child: CircleAvatar(
              child: Image.network(avatarImage != null
                  ? avatarImage
                  : 'https://images.rappi.com/products/2091421499-1579543158965.png?d=200x200'),
              backgroundColor: avatarColor,
              radius: Consts.avatarRadius,
            ),
          ),
        ],
      ),
    );
  }
}

class VoteItem extends StatefulWidget {
  final int index;
  final IntCallback voteAction;
  VoteItem({
    @required this.index,
    @required this.voteAction,
  });
  @override
  _VoteItemState createState() =>
      _VoteItemState(index: index, voteAction: voteAction);
}

class _VoteItemState extends State<VoteItem> {
  Color color;
  final int index;
  final IntCallback voteAction;
  _VoteItemState({
    @required this.index,
    @required this.voteAction,
  });

  @override
  void initState() {
    super.initState();
    color = Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          color = color == Colors.green ? Colors.grey : Colors.green;
        });
        voteAction(index + 1);
      },
      child: Container(
          child: Center(
        child: CircleAvatar(
          backgroundColor: color,
          child: new Text(
            '${index + 1}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      )),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
