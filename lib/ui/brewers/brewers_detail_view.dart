import 'dart:math' as math;
import 'dart:ui';

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewer_content.dart';
import 'package:craftbeer/ui/brewers/brewer_header.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      return FutureBuilder(
          future: brewerData.getBrewerById(widget.brewerId),
          builder: (context, snapshot) {
            if (brewerData.currentBrewer == null && !snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: LoadingWidget(),
                ),
              );
            }
            return Scaffold(
              body: Container(
                color: Colors.black87,
                child: Stack(
                  children: <Widget>[
                    SafeArea(
                      child: WillPopScope(
                        onWillPop: () =>
                            updateFavoriteIfChanged(brewerData, context),
                        child: BrewerHeader(
                          brewer: brewerData.currentBrewer,
                          onFavSelected:
                              brewerData.changeCurrentBrewerFavoriteState,
                          oniOSBackPressed: () =>
                              updateFavoriteIfChanged(brewerData, context),
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
                                child: BrewerContent(
                                  brewer: brewerData.currentBrewer,
                                  headerTopMargin: headerTopMargin,
                                )),
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
                onPressed: () =>
                    openWhatsApp(brewerData.currentBrewer, context),
              ),
            );
          });
    });
  }
}
