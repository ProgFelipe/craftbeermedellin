import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopBeersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final beers = StreamBuilder(
      stream: db.fetchTopBeers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          debugPrint('Top cervezas ${snapshot.data.documents}');
          return Row(
              children: List.generate(
                  snapshot.data.documents.length,
                  (index) =>
                      topBeerItem(snapshot.data.documents[index], context)));
        } else {
          return SizedBox(
            height: 10.0,
          );
        }
      },
    );

    return Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: beers);
  }
}

Widget topBeerItem(DocumentSnapshot beerSnapshot, context) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) => BeerDetailDialog(
                title: beerSnapshot.data['name'],
                description: beerSnapshot.data['description'] ?? '',
                avatarImage: beerSnapshot.data['imageUri'],
                buttonText: "Volver",
                starts: true,
                actionText: "Contactanos",
                action: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BrewersDetail(
                          beerSnapshot.data['brewer'].documentID)));
                },
              ));
    },
    child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Card(
            child: CachedNetworkImage(
              height: 90.0,
              fadeInDuration: Duration(milliseconds: 1500),
              imageUrl: beerSnapshot.data['imageUri'] ?? '',
              fit: BoxFit.scaleDown,
              placeholder: (context, url) => Image.network(
                url,
                height: 90.0,
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/beer.png',
                height: 90.0,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 10.0,
          child: Text(
            beerSnapshot.data['name'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white30),
          ),
        )
      ],
    ),
  );
}
