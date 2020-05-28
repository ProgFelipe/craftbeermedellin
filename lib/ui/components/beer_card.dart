import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/ui/brewers/beer_detail_view.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';

const kBeerCardHeight = 200.0;
const kBeerCardWidth = 150.0;

class BeerCard extends StatelessWidget {
  final Beer beer;

  BeerCard({@required this.beer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BeerDetailView(selectedBeer: beer,)));
      },
      child: Container(
        height: kBeerCardHeight,
        width: kBeerCardWidth,
        alignment: Alignment.center,
        child: Card(
          elevation: kCardElevation,
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                  Radius.circular(kCardRadius)
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageProviderWidget(
                beer.imageUri,
              ),
              Text(
                beer.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: kMoonlitAsteroidStartColor, fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}