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
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 15.0, vertical: headerTopMargin),
      child: Column(
        children: <Widget>[
          Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0)
          ),),),
          SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: brewer.promotions != null && brewer.promotions.length > 0,
            child: Column(
              children: [
                titleView(S.of(context).offers,
                    color: Colors.black, size: 20.0),
                Offers(promos: brewer.promotions),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          BrewerBeersWidget(),
          Visibility(
            visible: brewer.canSale,
            child: Card(
              color: Colors.black38,
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
