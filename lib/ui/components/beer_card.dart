import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

const kBeerCardHeight = 140.0;
const kBeerCardWidth = 100.0;

class BeerCard extends StatelessWidget {
  final Beer beer;

  BeerCard({@required this.beer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(brewerId: beer.brewerId)));
      },
      child: Container(
        height: kBeerCardHeight,
        width: kBeerCardWidth,
        alignment: Alignment.center,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                  Radius.elliptical(0, 0)
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
                style: TextStyle(color: kMoonlitAsteroidStartColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}