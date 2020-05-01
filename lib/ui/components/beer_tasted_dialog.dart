import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';

class BeerTastedDialog extends StatefulWidget {
  final String title, beerDescription, saveAndBackButtonText, historyButtonText;
  final Color avatarColor;
  final String avatarImage;
  final Function onShowHistory; //int vote, String comment, bool tasted
  final Function onTastedMark;

  BeerTastedDialog({
    @required this.title,
    @required this.beerDescription,
    @required this.saveAndBackButtonText,
    this.avatarColor,
    this.avatarImage,
    this.historyButtonText,
    this.onTastedMark,
    this.onShowHistory,
  });

  @override
  _BeerTastedDialogState createState() => _BeerTastedDialogState();
}

class _BeerTastedDialogState extends State<BeerTastedDialog> {
  bool _tasted = false;
  bool _canVote = true;

  void onVote(int vote) {
    setState(() {
      _canVote = false;
    });
    widget.onTastedMark(vote);
  }

  set tasted(bool value){
    setState(() {
      _tasted = value;
    });
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.beerDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: !_tasted,
                    child: Text(
                      S.of(context).do_you_tasted,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_tasted,
                    child: SizedBox(
                      height: 15.0,
                    ),
                  ),
                  Visibility(
                    visible: !_tasted,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      FlatButton.icon(onPressed: (){tasted = true;}, icon: Icon(BeerIcon.tasted_full, color: Colors.green), label: Text( S.of(context).yes)),
                      FlatButton.icon(onPressed: (){tasted = false;}, icon: Icon(BeerIcon.tasted_empty, color: Colors.grey), label: Text( S.of(context).no)),
                    ],),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: _tasted && _canVote,
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
                                onTastedMark: onVote,
                              )).toList(),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _tasted && !_canVote,
                    child: Text(
                      S.of(context).thanks_for_the_vote,
                      style: TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  Visibility(
                    visible: _tasted,
                    child: TextFormField(
                      maxLength: 280,
                      decoration: InputDecoration(
                          labelText:  S.of(context).comment_beer_hint,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Visibility(
                        visible: widget.historyButtonText != null,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onShowHistory(); // To close the dialog
                          },
                          child: widget.historyButtonText != null ? Text(widget.historyButtonText) : Text(''),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(widget.saveAndBackButtonText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: Consts.padding,
            right: Consts.padding,
            child: CircleAvatar(
              child: ImageProviderWidget(widget.avatarImage),
              backgroundColor: widget.avatarColor,
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
  final Function onTastedMark;
  VoteItem({
    @required this.index,
    @required this.onTastedMark,
  });
  @override
  _VoteItemState createState() =>
      _VoteItemState();
}

class _VoteItemState extends State<VoteItem> {
  Color color;

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
        widget.onTastedMark(widget.index);
      },
      child: Container(
          child: Center(
            child: CircleAvatar(
              backgroundColor: color,
              child: new Text(
                '${widget.index + 1}',
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
