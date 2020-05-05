import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/brewers/brewer_beers.dart';
import 'package:craftbeer/ui/brewers/offers.dart';
import 'package:craftbeer/ui/brewers/social_item.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class BrewerContent extends StatelessWidget {
  final Brewer brewer;
  final double headerTopMargin;

  BrewerContent({@required this.brewer, @required this.headerTopMargin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 15.0, vertical: headerTopMargin),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: brewer.promotions != null && brewer.promotions.length > 0,
            child: Column(
              children: [
                titleView(S.of(context).offers,
                    color: Colors.black, size: 30.0, padding: 0.0),
                Offers(promos: brewer.promotions),
              ],
            ),
          ),
          titleView(S.of(context).our_beers,
              color: Colors.black, size: 30.0, padding: 0.0),
          BrewerBeersWidget(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SocialItem(
                  visible: brewer.instagram.isNotEmpty,
                  uri: brewer.instagram,
                  icon: BeerIcon.instagram),
              SocialItem(
                  visible: brewer.facebook.isNotEmpty,
                  uri: brewer.facebook,
                  icon: BeerIcon.facebook),
              SocialItem(
                  visible: brewer.youtube.isNotEmpty,
                  uri: brewer.youtube,
                  icon: BeerIcon.youtube),
            ],
          ),
        ],
      ),
    );
  }
}
