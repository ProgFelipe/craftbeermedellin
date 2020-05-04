import 'dart:ui';
import 'dart:math' as math;

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/brewers/brewer_beers.dart';
import 'package:craftbeer/ui/brewers/offers.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BrewerContent extends StatefulWidget {
  final Brewer brewer;

  BrewerContent(this.brewer);

  @override
  _BrewerContentState createState() => _BrewerContentState();
}

class _BrewerContentState extends State<BrewerContent> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
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
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: headerTopMargin),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible:
                      widget.brewer.promotions != null && widget.brewer.promotions.length > 0,
                      child: Column(
                        children: [
                          titleView(S
                              .of(context)
                              .offers,
                              color: Colors.black, size: 30.0, padding: 0.0),
                          Offers(widget.brewer.promotions),
                        ],
                      ),
                    ),
                    titleView(S
                        .of(context)
                        .our_beers,
                        color: Colors.black, size: 30.0, padding: 0.0),
                    BrewerBeersWidget(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Visibility(
                          visible: widget.brewer.instagram.isNotEmpty,
                          child: FlatButton(
                            onPressed: () {
                              _launchInBrowser(widget.brewer.instagram);
                            },
                            child: Icon(BeerIcon.instagram, size: 40.0,)
                          ),
                        ),
                        Visibility(
                          visible: widget.brewer.facebook.isNotEmpty,
                          child: FlatButton(
                            onPressed: () {
                              _launchInBrowser(widget.brewer.facebook);
                            },
                            child: Icon(BeerIcon.facebook, size: 40.0,)
                          ),
                        ),
                        Visibility(
                          visible: widget.brewer.youtube.isNotEmpty,
                          child: FlatButton(
                            onPressed: () {
                              _launchInBrowser(widget.brewer.youtube);
                            },
                            child: Icon(BeerIcon.youtube, size: 40.0,)
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }


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
}
