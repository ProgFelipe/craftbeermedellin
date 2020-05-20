import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/brewers/beer_detail_view.dart';
import 'package:craftbeer/ui/brewers/beer_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewerBeersWidget extends StatefulWidget {
  @override
  _BrewerBeersWidgetState createState() => _BrewerBeersWidgetState();
}

class _BrewerBeersWidgetState extends State<BrewerBeersWidget> {
  showBeerDialog(context, BrewersData model, int index) {
    Beer beer = model.currentBrewer.beers[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeerDetailView(
          onTastedMark: (bool tasted) {
            model.sendBeerFeedback(beer, index);
          },
          selectedBeer: beer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(
      builder: (context, brewerData, child) {
        if (brewerData.currentBrewer.beers.isEmpty) {
          return Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/empty_state_beers.gif',
                    scale: 1.7,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Muy Pronto',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        }
        return Flexible(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.2),
            ),
            itemCount: brewerData.currentBrewer.beers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => showBeerDialog(context, brewerData, index),
                  child: BeerItem(
                    beer: brewerData.currentBrewer.beers[index],
                  ));
            },
          ),
        );
      },
    );
  }
}

Widget beerPropertiesText(String propertyName, num value) {
  return RichText(
      text: TextSpan(
    style: TextStyle(
      fontSize: 10.0,
      wordSpacing: 2.0,
      letterSpacing: 2.0,
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: propertyName + ' ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: value.toString(),
      )
    ],
  ));
}
