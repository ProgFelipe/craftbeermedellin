import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBeersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      if(brewerData.loadingState){
        return LoadingWidget();
      }
      if (brewerData.beers == null || brewerData.beers.isEmpty) {
        return Container(
          child: Column(
            children: [
              Image.asset(
                'assets/empty_state_topbeers.png',
                width: kEmptyStateWidth,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                S.of(context).empty_state_top_beers,
                style: TextStyle(
                    color: emptyStateTextColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
      }
      return FutureBuilder(
          future: brewerData.fetchTopBeers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            return Container(
              width: double.infinity,
              height: kBeerCardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length ?? 0,
                itemBuilder: (context, index) =>
                    BeerCard(beer: snapshot.data[index]),
              ),
            );
          });
    });
  }
}
