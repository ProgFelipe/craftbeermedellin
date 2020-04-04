import 'package:flutter/material.dart';

class BeerCategory extends StatelessWidget {
  const BeerCategory({Key key}) : super(key: key);

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
