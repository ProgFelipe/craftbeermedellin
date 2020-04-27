import 'package:craftbeer/search/categories_widget.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/search/brewers_grid.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(child: Column(children: [
          ConnectivityWidget(),
          titleView(S.of(context).local_brewers, color: Colors.black),
          BrewersGrid(),
          titleView(S.of(context).categories, color: Colors.black),
          CategoriesView(),
        ],)),
      ),
    );
  }
}