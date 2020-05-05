import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/beer_detail_view.dart';
import 'package:craftbeer/ui/brewers/start_rating.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewerBeersWidget extends StatefulWidget {
  @override
  _BrewerBeersWidgetState createState() => _BrewerBeersWidgetState();
}

class _BrewerBeersWidgetState extends State<BrewerBeersWidget> {
  showBeerDialog(context, BrewersData model, int index) {
    Beer beer = model.currentBrewer.beers[index];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BeerDetailView(
                onTastedMark: (bool tasted, int vote, String comment) {
                  if (tasted) {
                    beer.doITasted = tasted;
                    if (vote != null && vote != beer.myVote) {
                      beer.myVote = vote;
                    }
                    if (comment != null && comment != beer.myComment) {
                      beer.myComment = comment;
                    }
                    model.sendBeerFeedback(beer, index);
                  }
                },
                selectedBeer: beer,
                saveAndBackButtonText: S.of(context).back,
                avatarColor: Colors.orangeAccent[200],
                avatarImage: beer.imageUri,
                tastedStatus: beer.doITasted,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(
      builder: (context, brewerData, child) {
        if (brewerData.currentBrewer.beers.isEmpty) {
          return Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/emptybeers.gif',
                    scale: 1.7,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Muy Pronto',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        }
        return Flexible(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.2),
            ),
            itemCount: brewerData.currentBrewer.beers.length,
            itemBuilder: (context, index) {
              final beer = brewerData.currentBrewer.beers[index];
              return GestureDetector(
                onTap: () => showBeerDialog(context, brewerData, index),
                child: Stack(
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
                        StarRating(
                          rating: beer.ranking
                              .toDouble(),
                        ),
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget beerPropertiesText(String propertyName, num value) {
  return RichText(
      text: TextSpan(
    style: TextStyle(
      fontSize: 10.0,
      wordSpacing: 2.0,
      letterSpacing: 2.0,
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: propertyName + ' ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: value.toString(),
      )
    ],
  ));
}
