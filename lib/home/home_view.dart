import 'dart:ui';

import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/home/promotions.dart';
import 'package:craftbeer/home/new_releases.dart';
import 'package:craftbeer/home/search_view.dart';
import 'package:craftbeer/home/top_beers.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with AutomaticKeepAliveClientMixin<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.black87,
      child: SafeArea(
        child: SingleChildScrollView(
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
                  child: SearchWidget()),
              titleView(S.of(context).top_week_title),
              TopBeersView(),
              titleView(S.of(context).promotions_title),
              PromotionsWidget(),
              Image.asset('assets/tiposcerveza.png'),
              Image.asset('assets/colorescerveza.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
