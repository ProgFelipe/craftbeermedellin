import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/search/brewers_grid.dart';
import 'package:craftbeer/ui/search/categories_widget.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void scrollUp() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Expanded(
              child: Column(
                children: [
                  ConnectivityWidget(),
                  titleView(S.of(context).local_brewers, color: Colors.black),
                  BrewersGrid(),
                  titleView(S.of(context).categories, color: Colors.black),
                  CategoriesView(scrollUp),
                ],
              ),
            )),
      ),
    );
  }
}
