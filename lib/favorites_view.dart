import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Icon(
                  BeerIcon.beerglass,
                  size: 80.0,
                  color: Colors.grey,
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Icon(
                    Icons.favorite,
                    size: 40.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Agrega Favoritos',
              style: TextStyle(color: Colors.grey, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
