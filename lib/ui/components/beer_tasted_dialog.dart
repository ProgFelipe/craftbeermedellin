import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';

class BeerTastedDialog extends StatefulWidget {
  final String saveAndBackButtonText;
  final Color avatarColor;
  final String avatarImage;
  final Function onTastedMark;
  final Beer selectedBeer;

  BeerTastedDialog({
    @required this.saveAndBackButtonText,
    this.avatarColor,
    this.selectedBeer,
    this.avatarImage,
    this.onTastedMark,
  });

  @override
  _BeerTastedDialogState createState() => _BeerTastedDialogState();
}

class _BeerTastedDialogState extends State<BeerTastedDialog> {
  bool _tasted = false;
  bool _canVote = true;
  int vote;
  String comment;

  void onVote(int vote) {
    setState(() {
      this.vote = vote;
      _canVote = false;
    });
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
                    widget.selectedBeer.name,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.selectedBeer.description,
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
                    visible: widget.selectedBeer.doITasted || _tasted,
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
                                lastVote: widget.selectedBeer.myVote,
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
                    visible: widget.selectedBeer.doITasted || _tasted,
                    child: TextFormField(
                      initialValue: widget.selectedBeer.myComment ?? '',
                      onChanged: (value) => comment = value,
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
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(S.of(context).back),
                      ),
                      FlatButton(
                        onPressed: () {
                          widget.onTastedMark(_tasted, vote, comment);
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(S.of(context).save),
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
  final int lastVote;
  final Function onTastedMark;
  VoteItem({
    @required this.index,
    @required this.onTastedMark,
    @required this.lastVote,
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
              backgroundColor: widget.lastVote == widget.index ? Colors.green : color,
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
