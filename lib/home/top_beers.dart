import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class TopBeersView extends StatelessWidget {
  final db = DataBaseService();

  /*Future<List<Beer>> getTopBeers(List<Beer> allBeers) async{
    return await db.fetchTopBeersFromBeers(allBeers);
  }*/

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: db.fetchTopBeers(),
      child: Consumer<List<Beer>>(builder: (context, beers, child) {
        if (beers == null || beers.isEmpty) {
          return LoadingWidget();
        }
        return Container(
          child: Row(
            children: List.generate(
              beers.length ?? 0,
              (index) => Flexible(
                child: topBeerItem(beers[index], context),
              ),
            ),
          ),
        );
      }),
    );
  }
}

Widget topBeerItem(Beer beer, context) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) => BeerDetailDialog(
                title: beer.name,
                description: beer.description,
                avatarImage: beer.imageUri,
                buttonText: "Volver",
                starts: true,
                actionText: "Contactanos",
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BrewersDetail(
                            brewerRef: beer.brewerRef,
                          )));
                },
              ));
    },
    child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Card(
            child: ImageProviderWidget(beer.imageUri),
            /*CachedNetworkImage(
              height: 90.0,
              fadeInDuration: Duration(milliseconds: 1500),
              imageUrl: beer.imageUri,
              fit: BoxFit.scaleDown,
              placeholder: (context, url) => Image.network(
                url,
                height: 90.0,
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/beer.png',
                height: 90.0,
              ),
            ),*/
          ),
        ),
        Text(
          beer.name,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white30),
        )
      ],
    ),
  );
}
