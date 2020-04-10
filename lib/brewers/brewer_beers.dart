import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewerBeersWidget extends StatefulWidget {
  final List<dynamic> beersIds;

  BrewerBeersWidget({this.beersIds});

  @override
  _BrewerBeersWidgetState createState() =>
      _BrewerBeersWidgetState(beersRef: beersIds);
}

class _BrewerBeersWidgetState extends State<BrewerBeersWidget> {
  final List<String> beersRef;
  final db = DataBaseService();
  bool _showBeerDescription = false;
  String _beerName;
  String _beerHistory;

  _BrewerBeersWidgetState({this.beersRef});

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
    List<Beer> beers = Provider.of<List<Beer>>(context);
    if (beers == null) {
      return LoadingWidget();
    }
    return Column(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(
            beersRef.length,
            (index) => FutureBuilder(
                future: db.futureBeerByReference(beers, beersRef[index]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  return GestureDetector(
                    onTap: () =>
                        showBeerDialog(context, snapshot.data, beersRef[index]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ImageProviderWidget(snapshot.data.imageUri),
                        ),
                        SizedBox(height: 10.0),
                        beerPropertiesText(
                            S.of(context).ibu, snapshot.data.ibu),
                        beerPropertiesText(
                            S.of(context).abv, snapshot.data.abv),
                        Text('${snapshot.data.name}'),
                      ],
                    ),
                  );
                }),
          ),
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
