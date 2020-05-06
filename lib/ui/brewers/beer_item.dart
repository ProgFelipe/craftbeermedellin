import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/brewers/brewer_beers.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';

class BeerItem extends StatelessWidget {
  final Beer beer;
  BeerItem({@required this.beer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: beer.name,
                child: ImageProviderWidget(
                  beer.imageUri,
                  height: 100.0,
                ),
              ),
            ),
            Text(
              '${beer.name}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
            beerPropertiesText(S.of(context).ibu,
                beer.ibu),
            beerPropertiesText(S.of(context).abv,
                beer.abv),
            beerPropertiesText(S.of(context).srm,
                beer.srm),
            Text(
              '\$ ${beer.price}',
              style: TextStyle(
                fontSize: 15.0,
                wordSpacing: 2.0,
                letterSpacing: 2.0,
                color: Colors.black,
              ),
            ),
            //TODO STARTS
            /*StarRating(
                          rating: beer.ranking
                              .toDouble(),
                        ),*/
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
        beer.doITasted
            ? Positioned(
            top: 0.0,
            right: 0.0,
            child: Icon(
              BeerIcon.tasted_full,
              color: Colors.green,
            ))
            : Positioned(
          top: 0.0,
          right: 0.0,
          child: Icon(
            BeerIcon.tasted_empty,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
