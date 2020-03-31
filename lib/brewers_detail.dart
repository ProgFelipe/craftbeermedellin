import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BrewersDetail extends StatefulWidget {
  final int item;
  BrewersDetail(this.item);

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState();
  }
}

class BrewersDetailState extends State<BrewersDetail> {
  bool isFavorite = false;

  _isFavorite(brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    setState(() {
      isFavorite = favorites.contains(brewerName);
    });
  }

  _changeFavorite(String brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites != null ?? favorites.contains(brewerName);
    isFavorite ? favorites.remove(brewerName) : favorites.add(brewerName);
    print('Brewer is favorite: $exist ?.');
    await prefs.setStringList('favorites', favorites);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Color fetchBeerColor(String type) {
    switch (type.toLowerCase()) {
      case 'ipa':
        return Colors.orange;
      case 'pale ale':
        return Colors.orange[500];
      case 'stout':
        return Colors.brown[700];
      case 'pilsen':
        return Colors.yellow[500];
      case 'porter':
        return Colors.black54;
      case 'amber':
        return Colors.orange[400];
      case 'doppelbock':
        return Colors.brown;
      case 'bock':
        return Colors.yellow[300];
      case 'dunkel':
        return Colors.brown[700];
      case 'marzen':
        return Colors.orange[200];
      case 'raunchbier':
        return Colors.orangeAccent;
      case 'weizenbier':
        return Colors.yellow[600];
      case 'weizenbock':
        return Colors.brown[400];
      case 'kÖlsh':
        return Colors.yellow;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('brewers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                //title: Text(widget.event.data['name'], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
                title: Text(''),
              ),
              body: Center(
                child: Text('There are no brewers loading...'),
              ));
        }
        _isFavorite(snapshot.data.documents[widget.item]['name']);
        return Scaffold(
          appBar: AppBar(
            //title: Text(widget.event.data['name'], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
            title: Text("${snapshot.data.documents[widget.item]['name']}"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                    fadeInCurve: Curves.bounceInOut,
                    imageUrl:
                        snapshot.data.documents[widget.item]['imageUri'] ?? '',
                    width: 100.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[widget.item]['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                          Container(
                            child: Icon(Icons.error),
                          ),
                        ],
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'Cerveceria ${snapshot.data.documents[widget.item]['name']}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            maxLines: 5,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            snapshot.data.documents[widget.item]['description'],
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                            maxLines: 5,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () async {
                              FlutterOpenWhatsapp.sendSingleMessage(
                                  snapshot.data.documents[widget.item]['phone'],
                                  "${snapshot.data.documents[widget.item]['name']}\nMe gustaría comprar una cerveza\n[CraftBeer Colombia]");
                            },
                            icon: Icon(Icons.phone),
                            label: RichText(
                              text: TextSpan(
                                text: 'Pedir Whatsapp',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              _changeFavorite(
                                  snapshot.data.documents[widget.item]['name']);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 40.0,
                              color: Colors.red,
                            ),
                            label: Text('Favorito'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TitleTextUtils('Nuestras Cervezas', Colors.black, 40.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.documents[widget.item]['brewingOn'].length,
                    (index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              BeerIcon.beerglass,
                              size: 60.0,
                              color: fetchBeerColor(
                                  snapshot.data.documents[widget.item]
                                          ['brewingOn'][index]['name'] ??
                                      ''),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'IBU: ${snapshot.data.documents[widget.item]['brewingOn'][index]['ibu'] ?? ''}',
                                  style: TextStyle(fontSize: 9.0),
                                ),
                                Text(
                                  'ABV: ${snapshot.data.documents[widget.item]['brewingOn'][index]['abv'] ?? ''}',
                                  style: TextStyle(fontSize: 9.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                            '${snapshot.data.documents[widget.item]['brewingOn'][index]['name']}'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
