import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/delivery_picker.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/components/ios_back_nav.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double kPadding = 16.0;
const double kAvatarRadius = 66.0;

class BeerDetailView extends StatefulWidget {
  final Beer selectedBeer;

  BeerDetailView({this.selectedBeer});

  @override
  _BeerDetailViewState createState() => _BeerDetailViewState();
}

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

  void goToDeliveryLocationPickView() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DeliveryPicker(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      return FutureBuilder(
        future: brewerData.getBrewerById(widget.selectedBeer.brewerId),
        builder: (context, snapshot) => Scaffold(
          backgroundColor: kBlackLightColor,
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: kGreenColor,
            child: Icon(BeerIcon.car),
            onPressed: () {
              if (snapshot.hasData) {
                ///Open Map to choose delivery location.
                goToDeliveryLocationPickView();
              }
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: IosBackNav()),
                  Container(
                    padding: EdgeInsets.only(
                      top: kAvatarRadius + kPadding,
                      bottom: kPadding,
                      left: kPadding,
                      right: kPadding,
                    ),
                    margin: EdgeInsets.only(top: kAvatarRadius),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(kPadding),
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
                        Visibility(
                          visible: snapshot.hasData,
                          child: FlatButton.icon(
                            onPressed: () {},
                            icon: Icon(BeerIcon.beer_filled),
                            label: Text(
                              '${brewerData.currentBrewer.name}',
                              style: TextStyle(fontSize: 20.0),
                            ),
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
                                    color: _tasted
                                        ? kGreenColor
                                        : Colors.grey[400]),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                  graphBarItem(
                                      context,
                                      widget.selectedBeer.candy,
                                      S.of(context).beer_detail_candy),
                                  graphBarItem(
                                      context,
                                      widget.selectedBeer.salty,
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
                      ],
                    ),
                  ),
                  Positioned(
                    left: kPadding,
                    right: kPadding,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ImageProviderWidget(
                            widget.selectedBeer.imageUri,
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            child: ImageProviderWidget(
                                widget.selectedBeer.imageUri),
                            backgroundColor: kCitrusStartCustomColor,
                            radius: kAvatarRadius,
                          ),
                          Container(
                            color: Colors.black12,
                            child: Icon(
                              Icons.zoom_in,
                              size: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
