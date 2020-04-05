import 'package:craftbeer/home/components/beer_filter.dart';
import 'package:craftbeer/utils.dart';
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
                titleView('Categories', color: Colors.black),
                CategoriesView(),
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
