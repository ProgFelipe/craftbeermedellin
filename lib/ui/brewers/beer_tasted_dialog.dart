import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class BeerDetailView extends StatefulWidget {
  final String saveAndBackButtonText;
  final Color avatarColor;
  final String avatarImage;
  final Function onTastedMark;
  final Beer selectedBeer;
  final bool tastedStatus;

  BeerDetailView({
    @required this.saveAndBackButtonText,
    this.avatarColor,
    this.tastedStatus,
    this.selectedBeer,
    this.avatarImage,
    this.onTastedMark,
  });

  @override
  _BeerDetailViewState createState() => _BeerDetailViewState();
}

class _BeerDetailViewState extends State<BeerDetailView> {
  bool _tasted = false;
  bool _canVote = true;
  int _vote;
  String _comment;

  @override
  void initState() {
    _tasted = widget.tastedStatus;
    super.initState();
  }

  void onVote(int vote) {
    setState(() {
      this._vote = vote;
      _canVote = false;
    });
  }

  set tasted(bool value) {
    setState(() {
      _tasted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moonlitAsteroidMidColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  // To make the card compact
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: citrusStartCustomColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1.0)),
                                ),
                                child: Text(
                                  widget.selectedBeer.ibu.toString(),
                                ),
                              ),
                            ),
                            Text('IBU')
                          ],
                        ),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: citrusStartCustomColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Text(widget.selectedBeer.abv.toString()),
                              ),
                            ),
                            Text('ABV')
                          ],
                        ),
                        Column(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 70.0,
                                height: 70.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: citrusStartCustomColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Text(widget.selectedBeer.srm.toString()),
                              ),
                            ),
                            Text('SRM')
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      widget.selectedBeer.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Card(
                      color: moonlitAsteroidStartColor,
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 100.0,
                                  color: Colors.green,
                                ),
                                Text(
                                  'Amarga',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 120.0,
                                  color: Colors.green,
                                ),
                                Text('Dulce',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 10.0,
                                  color: Colors.green,
                                ),
                                Text('Salada',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 120.0,
                                  color: Colors.green,
                                ),
                                Text('Picante',
                                    style: TextStyle(color: Colors.white))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Visibility(
                      visible: widget.selectedBeer.history?.isNotEmpty ?? false,
                      child: Card(
                        color: Colors.green,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15.0),
                          margin: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                'Historia',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black54),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                widget.selectedBeer.history,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 2.0,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Visibility(
                      visible: !widget.selectedBeer.doITasted,
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
                          FlatButton.icon(
                              onPressed: () {
                                tasted = true;
                              },
                              icon: Icon(BeerIcon.tasted_full,
                                  color: Colors.green),
                              label: Text(S.of(context).yes)),
                          FlatButton.icon(
                              onPressed: () {
                                tasted = false;
                              },
                              icon: Icon(BeerIcon.tasted_empty,
                                  color: Colors.grey),
                              label: Text(S.of(context).no)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Card(
                      color: moonlitAsteroidStartColor,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Visibility(
                              visible: widget.selectedBeer.doITasted || _tasted,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    S.of(context).do_you_like_it,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: Iterable<Widget>.generate(
                                        5,
                                        (index) => VoteItem(
                                              index: index,
                                              lastVote:
                                                  widget.selectedBeer.myVote,
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
                            SizedBox(
                              height: 20.0,
                            ),
                            Visibility(
                              visible: widget.selectedBeer.doITasted || _tasted,
                              child: TextFormField(
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                initialValue:
                                    widget.selectedBeer.myComment ?? '',
                                onChanged: (value) => _comment = value,
                                maxLength: 280,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: S.of(context).comment_beer_hint,
                                  fillColor: Colors.white,
                                  counterStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // To close the dialog
                                  },
                                  child: Text(
                                    S.of(context).back,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    widget.onTastedMark(
                                        _tasted, _vote, _comment);
                                    Navigator.of(context)
                                        .pop(); // To close the dialog
                                  },
                                  child: Text(
                                    S.of(context).save,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: Consts.padding,
                right: Consts.padding,
                child: CircleAvatar(
                  child: Hero(
                      tag: widget.selectedBeer.name,
                      child: ImageProviderWidget(widget.avatarImage)),
                  backgroundColor: widget.avatarColor,
                  radius: Consts.avatarRadius,
                ),
              ),
            ],
          ),
        ),
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
  _VoteItemState createState() => _VoteItemState();
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
          backgroundColor:
              widget.lastVote == widget.index ? Colors.green : color,
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
