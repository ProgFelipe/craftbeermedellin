import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/beers_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/beer_detail_dialog.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBeersView extends StatelessWidget {
  final DataBaseService db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    List<Beer> beers = Provider.of<BeersData>(context).beers;

    if (beers == null || beers.isEmpty) {
      return LoadingWidget();
    } else {
      return FutureBuilder(
        future: db.fetchTopBeers(beers),
        builder: (context, snapshot) => Container(
          child: Row(
            children: List.generate(
              beers.length ?? 0,
              (index) => Flexible(
                child: topBeerItem(beers[index], context),
              ),
            ),
          ),
        ),
      );
    }
  }
}

Widget topBeerItem(Beer beer, context) {
  void goToBrewerDetail(Beer beer) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BrewersDetail(
              brewerRef: beer.brewerRef,
            )));
  }

  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) => BeerDetailDialog(
              title: beer.name,
              description: beer.description,
              avatarImage: beer.imageUri,
              buttonText: S.of(context).back,
              starts: true,
              actionText: S.of(context).contact_us,
              action: () => goToBrewerDetail(beer)));
    },
    child: Column(
      children: <Widget>[
        Text(
          beer.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 140.0,
          child: Card(
            child: ImageProviderWidget(beer.imageUri),
          ),
        ),
      ],
    ),
  );
}
