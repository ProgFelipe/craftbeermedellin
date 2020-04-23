import 'package:craftbeer/brewers/start_rating.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'dart:math';
final _random = new Random();

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
              actionText: beer.history.isNotEmpty ? S.of(context).more_info : '',
              action: beer.history.isNotEmpty ? () {
                _showBeerHistory(beer.name, beer.history);
              } : (){},
              avatarColor: Colors.orangeAccent[200],
              avatarImage: beer.imageUri,
            ));
  }

  @override
  Widget build(BuildContext context) {
    if(beers.isEmpty){
      return Container(margin: EdgeInsets.symmetric(vertical: 20.0),child: Column(
        children: <Widget>[
          Image.asset('assets/emptybeers.gif', scale: 1.7,),
          SizedBox(height: 20.0,),
          Text('Muy Pronto', style: TextStyle(fontSize: 15.0, color: Colors.grey),)
        ],
      ),);
    }
    return Column(
      children: <Widget>[
        Visibility(
          visible: _showBeerDescription,
          child: Card(
            color: Colors.green,
            child: Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(onPressed:  () => _hideHistory(), icon: Icon(Icons.close), label: Text('')),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    _beerName == null ? '' : _beerName,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black54
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    _beerHistory ?? '',
                    style: TextStyle(
                        fontSize: 16.0,
                        letterSpacing: 2.0,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 1.0, mainAxisSpacing: 5.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.2),),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: beers.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () =>
                  showBeerDialog(context, beers[index], beers[index].brewerRef),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ImageProviderWidget(beers[index].imageUri, height: 100.0,),
                  ),
                  Text('${beers[index].name}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
                  beerPropertiesText(S.of(context).ibu, beers[index].ibu),
                  beerPropertiesText(S.of(context).abv, beers[index].abv),
                  beerPropertiesText(S.of(context).srm, beers[index].srm),
                  StarRating(rating: 5.0,)
                ],
              ),
            );
          },
        ),
      ],
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
