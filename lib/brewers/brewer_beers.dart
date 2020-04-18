import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';

class BrewerBeersWidget extends StatefulWidget {
  final List<Beer> beers;

  BrewerBeersWidget({this.beers});

  @override
  _BrewerBeersWidgetState createState() =>
      _BrewerBeersWidgetState(beers: beers);
}

class _BrewerBeersWidgetState extends State<BrewerBeersWidget> {
  final List<Beer> beers;
  final db = DataBaseService();
  bool _showBeerDescription = false;
  String _beerName;
  String _beerHistory;

  _BrewerBeersWidgetState({this.beers});

  _showBeerHistory(String beerName, String beerHistory) {
    setState(() {
      _beerName = beerName;
      _beerHistory = beerHistory;
      _showBeerDescription = true;
    });
  }

  _hideHistory() {
    setState(() {
      _showBeerDescription = false;
    });
  }

  showBeerDialog(context, Beer beer, String beerRef) {
    showDialog(
        context: context,
        builder: (BuildContext context) => BeerDetailDialog(
              title: beer.name,
              showVotesBox: true,
              voteAction: (int vote) {
                db.futureSetVoteBeer(beerRef, vote);
              },
              description: beer.description,
              buttonText: S.of(context).back,
              actionText: S.of(context).more_info,
              action: () {
                _showBeerHistory(beer.name, beer.history);
              },
              avatarColor: Colors.orangeAccent[200],
              avatarImage: beer.imageUri,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 1.0, mainAxisSpacing: 1.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: beers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () =>
                  showBeerDialog(context, beers[index], beers[index].brewerRef),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ImageProviderWidget(beers[index].imageUri),
                  ),
                  SizedBox(height: 10.0),
                  beerPropertiesText(S.of(context).ibu, beers[index].ibu),
                  beerPropertiesText(S.of(context).abv, beers[index].abv),
                  Text('${beers[index].name}'),
                ],
              ),
            );
          },
        ),
        Visibility(
          visible: _showBeerDescription,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              FlatButton(
                onPressed: () => _hideHistory(),
                color: Colors.grey[200],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _beerName == null ? '' : _beerName,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.grey,
                      size: 60.0,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                _beerHistory == null ? '' : _beerHistory,
                style: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                    color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget beerPropertiesText(String propertyName, num value) {
  return RichText(
      text: TextSpan(
    style: TextStyle(
      fontSize: 9.0,
      color: Colors.black,
    ),
    children: [
      TextSpan(
        text: propertyName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      TextSpan(
        text: value.toString(),
        style: TextStyle(fontSize: 9.0),
      )
    ],
  ));
}
