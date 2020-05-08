import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/components/beer_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBeersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      if (brewerData.beers == null || brewerData.beers.isEmpty) {
        return LoadingWidget();
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
                itemBuilder: (context, index) => BeerCard(beer: snapshot.data[index]),
              ),
            );
          });
    });
  }
}