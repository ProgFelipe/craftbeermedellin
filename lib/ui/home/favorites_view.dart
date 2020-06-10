import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kBigMargin,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20.0),
              child: Image.asset(
                'assets/skullflowers.png',
                height: 100.0,
                alignment: Alignment.topLeft,
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20.0),
                child: Container(
                  width: 200,
                  height: 20,
                  color: Colors.blueAccent,
                )),
            titleView(S.of(context).tasted_beers_title,
                margin: EdgeInsets.only(left: 20.0)),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            Consumer<BrewersData>(
              builder: (context, brewersData, child) {
                if (brewersData.tastedBeers != null &&
                    brewersData.tastedBeers.isEmpty) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  );
                }
                if (brewersData.tastedBeers != null &&
                    brewersData.tastedBeers.isNotEmpty) {
                  return Expanded(
                    child: Container(
                      width: double.infinity,
                      height: kBeerCardHeight,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: brewersData.tastedBeers.length,
                        itemBuilder: (context, index) =>
                            BeerCard(beer: brewersData.tastedBeers[index]),
                      ),
                    ),
                  );
                }
                return LoadingWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
