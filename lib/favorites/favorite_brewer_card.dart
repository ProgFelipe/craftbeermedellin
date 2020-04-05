import 'package:craftbeer/home/top_beers.dart';
import 'package:flutter/material.dart';

class FavoriteCard extends StatelessWidget {
  final String imageUri;
  final String title;
  FavoriteCard({this.imageUri, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Card(
        color: Colors.white,
        elevation: 20.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  imageUri,
                  fit: BoxFit.scaleDown,
                  height: 200.0,
                  width: 180.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                    height: 200.0,
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: TextStyle(fontFamily: 'Patua', fontSize: 30.0),
                        ),
                        Text(
                          'Somos fabricantes de bebidas artesanales en Envigado, nuestro propósito es mezclar el arte con la ciencia para crear momentos de calidad.',
                          overflow: TextOverflow.fade,
                          maxLines: 20,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontFamily: 'Patua',
                              fontSize: 12.0),
                        ),
                        Text('Envigado Colombia',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Patua',
                                fontSize: 14.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TopBeersView(),
          ],
        ),
      ),
    );
  }
}
