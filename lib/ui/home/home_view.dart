import 'dart:ui';

import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/home/articles.dart';
import 'package:craftbeer/ui/home/new_releases.dart';
import 'package:craftbeer/ui/home/search_view.dart';
import 'package:craftbeer/ui/home/top_beers.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void putScrollAtTop() {
    _scrollController.animateTo(
      240.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: kBlackColor,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConnectivityWidget(),
              BeerReleases(),
              SizedBox(
                height: kBigMargin,
              ),
              SearchWidget(putScrollAtTop),
              SizedBox(
                height: kBigMargin,
              ),
              Container(
                margin: EdgeInsets.only(left: kMarginLeft),
                child: Column(
                  children: [
                    titleView(S.of(context).top_week_title,
                        color: kWhiteColor),
                    SizedBox(
                      height: kMarginTopFromTitle,
                    ),
                    TopBeersView(),
                    SizedBox(
                      height: kBigMargin,
                    ),
                    titleView(S.of(context).home_learn_title,
                        color: kWhiteColor),
                    SizedBox(
                      height: kMarginTopFromTitle,
                    ),
                    ArticlesWidget(),
                    SizedBox(
                      height: kBigMargin,
                    ),
                  ],
                ),
              ),
              /*titleView('Feeds', color: Colors.white),
              LastComments(),*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
