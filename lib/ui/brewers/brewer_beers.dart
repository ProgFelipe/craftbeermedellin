import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/start_rating.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/beer_tasted_dialog.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewerBeersWidget extends StatefulWidget {
  final List<Beer> beers;

  BrewerBeersWidget({this.beers});

  @override
  _BrewerBeersWidgetState createState() => _BrewerBeersWidgetState();
}

class _BrewerBeersWidgetState extends State<BrewerBeersWidget> {
  BrewersData model;
  bool _showBeerDescription = false;
  String _beerName;
  String _beerHistory;

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

  showBeerDialog(context, Beer beer, int brewerId, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) => BeerTastedDialog(
              onTastedMark: (bool tasted, int vote, String comment) {
                print(comment);
                print(vote);
                print(tasted);
                if (tasted) {
                  beer.doITasted = tasted;
                  if (vote != null && vote != beer.myVote) {
                    beer.myVote = vote;
                  }
                  if (comment != null && comment != beer.myComment) {
                    beer.myComment = comment;
                  }
                  model.sendBeerFeedback(beer, index);

                  ///SEND BEER FEEDBACK BY USER
                }
              },
              selectedBeer: beer,
              saveAndBackButtonText: S.of(context).back,
              avatarColor: Colors.orangeAccent[200],
              avatarImage: beer.imageUri,
            ));
  }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<BrewersData>(context);

    if (widget.beers.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/emptybeers.gif',
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
      );
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
                  FlatButton.icon(
                      onPressed: () => _hideHistory(),
                      icon: Icon(Icons.close),
                      label: Text('')),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    _beerName == null ? '' : _beerName,
                    style: TextStyle(fontSize: 20.0, color: Colors.black54),
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
            crossAxisCount: 3,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.2),
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.beers.length,
          itemBuilder: (context, index) {
            var beer = widget.beers[index];
            return GestureDetector(
              onTap: () => showBeerDialog(context, widget.beers[index],
                  widget.beers[index].brewerId, index),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ImageProviderWidget(
                          widget.beers[index].imageUri,
                          height: 100.0,
                        ),
                      ),
                      Text(
                        '${widget.beers[index].name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      beerPropertiesText(
                          S.of(context).ibu, widget.beers[index].ibu),
                      beerPropertiesText(
                          S.of(context).abv, widget.beers[index].abv),
                      beerPropertiesText(
                          S.of(context).srm, widget.beers[index].srm),
                      Text(
                        '\$ ${widget.beers[index].price}',
                        style: TextStyle(
                          fontSize: 15.0,
                          wordSpacing: 2.0,
                          letterSpacing: 2.0,
                          color: Colors.black,
                        ),
                      ),
                      StarRating(
                        rating: widget.beers[index].ranking.toDouble(),
                      ),
                      Visibility(
                          visible: widget.beers[index].history.isNotEmpty,
                          child: FlatButton.icon(
                            onPressed: () =>
                                _showBeerHistory(beer.name, beer.history),
                            icon: Icon(
                              Icons.history,
                              color: Colors.white,
                            ),
                            label: Text(''),
                            color: Colors.green,
                          ))
                    ],
                  ),
                  widget.beers[index].doITasted
                      ? Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Icon(
                            BeerIcon.tasted_full,
                            color: Colors.green,
                          ))
                      : Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Icon(
                            BeerIcon.tasted_empty,
                            color: Colors.grey,
                          )),
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
