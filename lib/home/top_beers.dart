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

    return Container(height: 100.0, decoration: BoxDecoration(), child: beers);
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
    child: Card(
      elevation: 10.0,
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            height: 70.0,
            fadeInDuration: Duration(milliseconds: 1500),
            imageUrl: beerSnapshot.data['imageUri'] ?? '',
            fit: BoxFit.scaleDown,
            placeholder: (context, url) => Image.network(
              url,
              height: 70.0,
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/beer.png',
              height: 70.0,
            ),
          ),
          Text(
            beerSnapshot.data['name'],
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
