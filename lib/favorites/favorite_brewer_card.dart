import 'package:craftbeer/home/components/beer_filter.dart';
import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        elevation: 20.0,
        child: Column(
          children: <Widget>[
            Text('Guardian'),
            Image.asset(
              'assets/beertype.png',
              height: 80.0,
            ),
            Text('20 votos'),
            Text('Beers you love'),
            topBeersOfWeek(context)
          ],
        ),
      ),
    );
  }
}