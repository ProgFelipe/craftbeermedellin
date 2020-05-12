import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:craftbeer/ui/components/generic_empty_state.dart';
import 'package:craftbeer/ui/search/promotions.dart';
import 'package:craftbeer/ui/search/brewers_grid.dart';
import 'package:craftbeer/ui/search/categories_chips.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<String> titles = [
  'El aroma',
  'Que tipos de cerveza hay?',
  'La fermentación',
  'La temperatura',
  'El alcochol'
];

const List<String> images = [
  'assets/art_senses.jpg',
  'assets/art_beer_types.jpg',
  'assets/art_brewing.jpg',
  'assets/art_temperature.jpg',
  'assets/art_alcohol_levels.jpg'
];

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with AutomaticKeepAliveClientMixin<SearchView> {
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
    super.build(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [kBlackColor, kBlackLightColor])),
      child: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin: EdgeInsets.only(left: kMarginLeft),
              child: Column(
                children: [
                  ConnectivityWidget(),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  titleView(
                    S.of(context).promotions_title,
                  ),
                  SizedBox(
                    height: kMarginTopFromTitle,
                  ),
                  PromotionsWidget(),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  titleView(S.of(context).local_brewers),
                  SizedBox(
                    height: kMarginTopFromTitle,
                  ),
                  BrewersGrid(),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  titleView('Tasted beers'),
                  SizedBox(
                    height: kMarginTopFromTitle,
                  ),
                  Consumer<BrewersData>(
                    builder: (context, brewersData, child) {
                      if (brewersData.tastedBeers != null &&
                          brewersData.tastedBeers.isNotEmpty) {
                        return Container(
                          width: double.infinity,
                          height: kBeerCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: brewersData.tastedBeers.length,
                            itemBuilder: (context, index) =>
                                BeerCard(beer: brewersData.tastedBeers[index]),
                          ),
                        );
                      }
                      return GenericEmptyState();
                    },
                  ),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  SizedBox(
                    height: kBigMargin,
                  ),
                  titleView(S.of(context).categories),
                  //CategoriesView(scrollUp),
                  SizedBox(
                    height: kMarginTopFromTitle,
                  ),
                  CategoriesChips(),
                ],
              ),
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
