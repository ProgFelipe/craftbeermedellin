import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';

typedef IntCallback = Function(int num);

class BeerDetailDialog extends StatefulWidget {
  final String title, description, buttonText, actionText;
  final Color avatarColor;
  final String avatarImage;
  final VoidCallback action;
  final IntCallback voteAction;
  final bool starts, showVotesBox;

  BeerDetailDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.avatarColor,
    this.avatarImage,
    this.actionText,
    this.showVotesBox = false,
    this.voteAction,
    this.action,
    this.starts = false,
  });

  @override
  _BeerDetailDialogState createState() => _BeerDetailDialogState();
}

class _BeerDetailDialogState extends State<BeerDetailDialog> {

  bool _canVote = true;
  void onVote(int vote) {
    setState(() {
      _canVote = false;
    });
    widget.voteAction(vote);
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
                  visible: widget.starts,
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Visibility(
                  visible: widget.showVotesBox && _canVote,
                  child: Column(
                    children: <Widget>[
                      Text(
                        S.of(context).do_you_like_it,
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
                  visible: widget.showVotesBox && !_canVote,
                  child: Text(
                    S.of(context).thanks_for_the_vote,
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Visibility(
                      visible: widget.actionText != null,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.action(); // To close the dialog
                        },
                        child: widget.actionText != null ? Text(widget.actionText) : Text(''),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                      child: Text(widget.buttonText),
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
              child: ImageProviderWidget(widget.avatarImage),
              backgroundColor: Colors.white,
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
