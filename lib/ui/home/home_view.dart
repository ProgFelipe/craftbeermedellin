import 'dart:ui';

import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/home/articles.dart';
import 'package:craftbeer/ui/home/new_releases.dart';
import 'package:craftbeer/ui/home/search_view.dart';
import 'package:craftbeer/ui/home/top_beers.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with AutomaticKeepAliveClientMixin<Home> {

  ScrollController _scrollController =  ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void putScrollAtTop(){
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
      color: Colors.black87,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConnectivityWidget(),
              BeerReleases(),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Image.asset(
                  'assets/icon.png',
                  alignment: Alignment.center,
                  height: 100.0,
                ),
              ),
              Padding(
                  padding:
                  EdgeInsets.only(bottom: 40.0, left: 20.0, right: 20.0),
                  child: SearchWidget(putScrollAtTop)),
              titleView(S.of(context).top_week_title),
              TopBeersView(),
              titleView(S.of(context).home_learn_title),
              ArticlesWidget(),
              //titleView(S.of(context).promotions_title),
              //PromotionsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
