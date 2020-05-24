import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/components/ios_back_nav.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeerDetailView extends StatefulWidget {
  final Beer selectedBeer;
  final UniqueKey heroTagId;
  BeerDetailView({this.selectedBeer, this.heroTagId});

  @override
  _BeerDetailViewState createState() => _BeerDetailViewState();
}

const double barHeight = 24.0;

class _BeerDetailViewState extends State<BeerDetailView> {
  bool _tasted = false;

  @override
  void initState() {
    _tasted = widget.selectedBeer.doITasted;
    super.initState();
  }

  set tasted(bool value) {
    setState(() {
      _tasted = value;
    });
  }

  void updateBeer(bool tastedSelected, BrewersData model) {
    if (_tasted != tastedSelected) {
      widget.selectedBeer.doITasted = tastedSelected;
      model.sendBeerFeedback(widget.selectedBeer);
      setState(() {
        _tasted = tastedSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //BrewersData model = Provider.of<BrewersData>(context);
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      return Scaffold(
        backgroundColor: kBlackLightColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10.0), child: IosBackNav()),
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
                          beerProperty(
                              'IBU', widget.selectedBeer.ibu.toString()),
                          beerProperty(
                              'ABV', widget.selectedBeer.abv.toString()),
                          beerProperty(
                              'SRM', widget.selectedBeer.srm.toString()),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        widget.selectedBeer.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        S.of(context).do_you_tasted,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton.icon(
                              onPressed: () {
                                updateBeer(true, brewerData);
                              },
                              icon: Icon(BeerIcon.tasted_full,
                                  color:
                                      _tasted ? kGreenColor : Colors.grey[400]),
                              label: Text(S.of(context).yes)),
                          FlatButton.icon(
                              onPressed: () {
                                updateBeer(false, brewerData);
                              },
                              icon: Icon(BeerIcon.tasted_empty,
                                  color: !_tasted
                                      ? kGreenColor
                                      : Colors.grey[400]),
                              label: Text(S.of(context).no)),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        height: 190.0,
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          color: kMoonlitAsteroidStartColor,
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Text('5',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      height: 24.0,
                                    ),
                                    Container(
                                      child: Text('4',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      height: 24.0,
                                    ),
                                    Container(
                                      child: Text('3',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      height: 24.0,
                                    ),
                                    Container(
                                      child: Text('2',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      height: 24.0,
                                    ),
                                    Container(
                                      child: Text('1',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      height: 24.0,
                                    ),
                                    Container(
                                      child: Text('0',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    )
                                  ],
                                ),
                                graphBarItem(
                                    context,
                                    widget.selectedBeer.bitter,
                                    S.of(context).beer_detail_bitter),
                                graphBarItem(context, widget.selectedBeer.candy,
                                    S.of(context).beer_detail_candy),
                                graphBarItem(context, widget.selectedBeer.salty,
                                    S.of(context).beer_detail_salty),
                                graphBarItem(
                                    context,
                                    widget.selectedBeer.hotSpicy,
                                    S.of(context).beer_detail_hot_spicy),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible:
                            widget.selectedBeer.history?.isNotEmpty ?? false,
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
                                  S.of(context).beer_detail_history_title,
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
                      /*SizedBox(
                        height: 15.0,
                      ),
                      Visibility(
                        visible: _tasted,
                        child:
                            FeedbackBox(widget.onTastedMark, widget.selectedBeer),
                      )*/
                    ],
                  ),
                ),
                Positioned(
                  left: Consts.padding,
                  right: Consts.padding,
                  child: CircleAvatar(
                    child: Hero(
                        tag: widget.heroTagId,
                        child:
                            ImageProviderWidget(widget.selectedBeer.imageUri)),
                    backgroundColor: kCitrusStartCustomColor,
                    radius: Consts.avatarRadius,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Column beerProperty(String propertyName, String propertyValue) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 70.0,
            height: 70.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kCitrusStartCustomColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Text(
              propertyValue,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          propertyName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        )
      ],
    );
  }

  Column graphBarItem(
      BuildContext context, int propertyValue, String propertyName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50.0,
          height: propertyValue * 24.0,
          color: Colors.green,
        ),
        Text(
          propertyName,
          style: TextStyle(color: Colors.white),
        )
      ],
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

class FeedbackBox extends StatefulWidget {
  final Function onSave;
  final Beer selectedBeer;

  FeedbackBox(this.onSave, this.selectedBeer);

  @override
  _FeedbackBoxState createState() => _FeedbackBoxState();
}

class _FeedbackBoxState extends State<FeedbackBox> {
  int _vote;
  String _comment;
  bool voted = false;
  bool _saving = false;

  void onVote(int vote) {
    setState(() {
      this._vote = vote;
      voted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kMoonlitAsteroidStartColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Visibility(
              visible: !_saving,
              child: Column(
                children: [
                  Text(
                    S.of(context).did_you_like_it,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Visibility(
                    visible: !voted,
                    child: Row(
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
                  ),
                  Visibility(
                    visible: voted,
                    child: Text(
                      S.of(context).thanks_for_the_vote,
                      style: TextStyle(color: Colors.amberAccent),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    initialValue: widget.selectedBeer.myComment ?? '',
                    onChanged: (value) => _comment = value,
                    maxLength: 280,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: S.of(context).tell_us_more,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      counterStyle: TextStyle(color: Colors.white),
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
                        child: Text(
                          S.of(context).back,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          widget.onSave(true, _vote, _comment);
                          setState(() {
                            _saving = true;
                          });
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
            Visibility(
                visible: _saving,
                child: Text(
                  S.of(context).beer_detail_thanks_for_feedback,
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
