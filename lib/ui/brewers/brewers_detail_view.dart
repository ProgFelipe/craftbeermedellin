import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewer_beers.dart';
import 'package:craftbeer/ui/brewers/offers.dart';
import 'package:craftbeer/ui/components/beer_detail_dialog.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//Parallax effect
//https://github.com/MarcinusX/buy_ticket_design/blob/master/lib/exhibition_bottom_sheet.dart

class BrewersDetail extends StatefulWidget {
  final int brewerId;

  BrewersDetail({this.brewerId});

  @override
  _BrewersDetailState createState() => _BrewersDetailState();
}

class _BrewersDetailState extends State<BrewersDetail>
    with SingleTickerProviderStateMixin {
  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  AnimationController _controller;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get maxHeight => MediaQuery.of(context).size.height;

  double get minHeight => (MediaQuery.of(context).size.height * 0.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openWhatsApp(Brewer brewer, context) async {
    String message =
        "${brewer.name}\n${S.of(context).i_would_like_to_to_buy_msg}";

    String url = 'whatsapp://send?phone=${brewer.phone}&text=$message';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).whatsapp_error),
        ));
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).whatsapp_error),
      ));
    }
  }

  updateFavoriteIfChanged(BrewersData brewersData, context) {
    brewersData.saveCurrentBrewerFavoriteState();
    Navigator.pop(context);
  }

  showBrewerMoreInfo(Brewer brewer, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => BeerDetailDialog(
        title: brewer.name,
        description: brewer.aboutUs,
        buttonText: S.of(context).back,
        avatarImage: brewer.imageUri,
        avatarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      return FutureBuilder(
        future: brewerData.getBrewerById(widget.brewerId),
        builder: (context, snapshot) => Scaffold(
          body: Container(
            color: Colors.black87,
            child: Stack(
              children: <Widget>[
                WillPopScope(
                  onWillPop: () => updateFavoriteIfChanged(brewerData, context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ConnectivityWidget(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Platform.isIOS
                                  ? FlatButton.icon(
                                      onPressed: () {
                                        updateFavoriteIfChanged(
                                            brewerData, context);
                                      },
                                      icon: Icon(
                                        Icons.home,
                                        size: 40.0,
                                        color: Colors.white,
                                      ),
                                      label: Text(''),
                                    )
                                  : SizedBox(),
                              Text(
                                brewerData.currentBrewer.name,
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Hero(
                              tag: brewerData.currentBrewer.name,
                              child: ImageProviderWidget(
                                brewerData.currentBrewer.imageUri,
                                height: 100.0,
                                animationDuration: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              brewerData.currentBrewer.description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Visibility(
                            visible: !brewerData.currentBrewer.canSale,
                            child: Card(
                              color: Colors.white10,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  child: Text(
                                    S.of(context).informed_consent,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        letterSpacing: 2.0),
                                  )),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible:
                                    brewerData.currentBrewer.aboutUs.isNotEmpty,
                                child: FlatButton.icon(
                                  color: Colors.black54,
                                  onPressed: () => showBrewerMoreInfo(
                                      brewerData.currentBrewer, context),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  label: RichText(
                                    text: TextSpan(
                                      text: S.of(context).know_us,
                                      style: new TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ),
                                ),
                              ),
                              FlatButton.icon(
                                onPressed: () {
                                  brewerData.changeCurrentBrewerFavoriteState();
                                },
                                icon: Icon(
                                  brewerData.currentBrewer.favorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 40.0,
                                  color: Colors.orange,
                                ),
                                label: Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        height: lerp(minHeight, maxHeight),
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _toggle,
                          onVerticalDragUpdate: _handleDragUpdate,
                          onVerticalDragEnd: _handleDragEnd,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: headerTopMargin),
                            child: Column(
                              children: <Widget>[
                                Visibility(
                                  visible:
                                      brewerData.currentBrewer.promotions !=
                                              null &&
                                          brewerData.currentBrewer.promotions
                                                  .length >
                                              0,
                                  child: Column(
                                    children: [
                                      titleView(S.of(context).offers,
                                          color: Colors.black,
                                          size: 30.0,
                                          padding: 0.0),
                                      Offers(
                                          brewerData.currentBrewer.promotions),
                                    ],
                                  ),
                                ),
                                titleView(S.of(context).our_beers,
                                    color: Colors.black,
                                    size: 30.0,
                                    padding: 0.0),
                                BrewerBeersWidget(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Visibility(
                                      visible: brewerData
                                          .currentBrewer.instagram.isNotEmpty,
                                      child: FlatButton(
                                          onPressed: () {
                                            _launchInBrowser(brewerData
                                                .currentBrewer.instagram);
                                          },
                                          child: Icon(
                                            BeerIcon.instagram,
                                            size: 40.0,
                                          )),
                                    ),
                                    Visibility(
                                      visible: brewerData
                                          .currentBrewer.facebook.isNotEmpty,
                                      child: FlatButton(
                                          onPressed: () {
                                            _launchInBrowser(brewerData
                                                .currentBrewer.facebook);
                                          },
                                          child: Icon(
                                            BeerIcon.facebook,
                                            size: 40.0,
                                          )),
                                    ),
                                    Visibility(
                                      visible: brewerData
                                          .currentBrewer.youtube.isNotEmpty,
                                      child: FlatButton(
                                          onPressed: () {
                                            _launchInBrowser(brewerData
                                                .currentBrewer.youtube);
                                          },
                                          child: Icon(
                                            BeerIcon.youtube,
                                            size: 40.0,
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green[600],
            child: brewerData.currentBrewer.canSale
                ? Icon(BeerIcon.car)
                : Icon(BeerIcon.user_filled),
            onPressed: () => openWhatsApp(brewerData.currentBrewer, context),
          ),
        ),
      );
    });
  }
}
