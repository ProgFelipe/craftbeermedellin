import 'package:flutter/material.dart';

class BeerCategory extends StatefulWidget {
  @override
  _BeerCategoryState createState() => _BeerCategoryState();
}

class _BeerCategoryState extends State<BeerCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset('assets/tiposcerveza.png'),
                Image.asset('assets/colorescerveza.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
