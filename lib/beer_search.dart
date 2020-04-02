import 'package:flutter/material.dart';

class BeerFinder extends StatefulWidget {
  @override
  _BeerFinderState createState() => _BeerFinderState();
}

class _BeerFinderState extends State<BeerFinder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            //buildCategorySearch(),
            CircleAvatar(
              child: Image.network(
                  'https://images.rappi.com.mx/products/976764882-1574446494426.png?d=200x200'),
              backgroundColor: Colors.orangeAccent[200],
              radius: 66.0,
            )
          ],
        ),
      ),
    );
  }
}
