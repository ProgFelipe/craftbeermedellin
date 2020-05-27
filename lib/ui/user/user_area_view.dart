import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:craftbeer/ui/user/brewers_grid.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAreaView extends StatefulWidget {
  @override
  _UserAreaViewState createState() => _UserAreaViewState();
}

class _UserAreaViewState extends State<UserAreaView>
    with AutomaticKeepAliveClientMixin<UserAreaView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: SingleChildScrollView(
            //controller: _scrollController,
            child: Column(
              children: [
                ConnectivityWidget(),
                Container(
                  margin: EdgeInsets.only(left: kMarginLeft),
                  child: Column(
                    children: [
                      SizedBox(
                        height: kBigMargin,
                      ),
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/brewers.png',
                          height: 80.0,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Container( alignment: Alignment.topLeft,child: Container(width: 200, height: 20, color: Colors.yellowAccent,)),
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
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/skullflowers.png',
                          height: 100.0,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      Container( alignment: Alignment.topLeft,child: Container(width: 200, height: 20, color: Colors.pinkAccent,)),
                      titleView(S.of(context).tasted_beers_title),
                      SizedBox(
                        height: kMarginTopFromTitle,
                      ),
                      Consumer<BrewersData>(
                        builder: (context, brewersData, child) {
                          if (brewersData.tastedBeers != null &&
                              brewersData.tastedBeers.isEmpty) {
                            return Container(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/empty_state_favorites.png',
                                    width: kEmptyStateWidth,
                                  ),
                                  Text(
                                    S.of(context).empty_state_favorite_beers,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            );
                          }
                          if (brewersData.tastedBeers != null &&
                              brewersData.tastedBeers.isNotEmpty) {
                            return Container(
                              width: double.infinity,
                              height: kBeerCardHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: brewersData.tastedBeers.length,
                                itemBuilder: (context, index) => BeerCard(
                                    beer: brewersData.tastedBeers[index]),
                              ),
                            );
                          }
                          return LoadingWidget();
                        },
                      ),
                      SizedBox(
                        height: kBigMargin,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
