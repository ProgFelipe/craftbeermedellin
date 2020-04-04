import 'package:craftbeer/brewers/brewer_bloc.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:flutter/material.dart';

class BrewerBeers extends StatefulWidget {
  final List<dynamic> beersIds;
  BrewerBeers({this.beersIds});
  @override
  _BrewerBeersState createState() => _BrewerBeersState(beers: beersIds);
}

class _BrewerBeersState extends State<BrewerBeers> {
  final List<dynamic> beers;
  bool _showBeerDescription = false;
  final BrewerBloc bloc = BrewerBloc();
  String _beerName;
  String _beerHistory;


  _BrewerBeersState({this.beers});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(
            beers.length,
            (index) => StreamBuilder(
              stream: bloc.getBeer(beers[index].documentID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('No data');
                }
                debugPrint("${snapshot.data['name']}");
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => BeerDetailDialog(
                              title: snapshot.data['name'],
                              showVotesBox: true,
                              voteAction: (int vote) {
                                debugPrint('Votó $vote');
                                bloc.setVoteBeer(beers[index].documentID, vote);
                              },
                              description:
                                  "${snapshot.data['name']} esta cerveza fue creada con un toque amargo y jengibre ideal para el clima",
                              buttonText: "Volver",
                              actionText: 'Conocé más',
                              action: () {
                                Navigator.of(context).pop();
                                _showBeerHistory(snapshot.data['name'],
                                    snapshot.data['history']);
                              },
                              avatarColor: Colors.orangeAccent[200],
                              avatarImage:
                                  'https://images.rappi.com.mx/products/976764882-1574446494426.png?d=200x200',
                            ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        BeerIcon.beerglass,
                        size: 60.0,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(height: 10.0),
                      beerPropertiesText('IBU: ', snapshot.data['ibu']),
                      beerPropertiesText('ABV: ', snapshot.data['abv']),
                      Text(
                        //'ABV: ${bloc.getAbv(snapshot, index)}',
                        '',
                        style: TextStyle(
                            fontSize: 10.0,
                            fontFamily: 'Patua',
                            fontWeight: FontWeight.bold),
                      ),
                      Text('${snapshot.data['name']}'),
                    ],
                  ),
                );
              },
            ),
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
                        style: TextStyle(fontSize: 25.0, fontFamily: 'Patua'),
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
  return Visibility(
    visible: value != null,
    child: Text(
      propertyName + value.toString(), //'IBU: ${bloc.getBeerName(snapshot)}',
      style: TextStyle(fontSize: 9.0),
    ),
  );
}
