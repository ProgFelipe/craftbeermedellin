import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/categories/categories_widget.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class BeerCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ConnectivityWidget(),
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
