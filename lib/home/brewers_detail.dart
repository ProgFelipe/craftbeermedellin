import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/components/beer_detail.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/main_bloc.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BrewersDetail extends BaseView {
  final int item;

  BrewersDetail(this.item);

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState(item: item);
  }
}

class BrewersDetailState extends BaseViewState<BrewersDetail> {
  bool isFavorite = false;
  final int item;

  BrewersDetailState({this.item});

  static const String apiRoot = 'brewers';
  static const String brewName = 'name';
  static const String brewsReleases = 'brewingOn';
  static const String ibu = 'ibu';
  static const String abv = 'abv';

  final bloc = MainBloc();

  _isFavorite(String brewerName) async {
    await bloc.isFavorite(brewerName).then((value) {
      setState(() {
        isFavorite = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    initInternetValidation();

    return StreamBuilder(
      stream: Firestore.instance.collection(apiRoot).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                //title: Text(widget.event.data[brewName], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
                title: Text(''),
              ),
              body: Center(
                child: Text('There are no brewers loading...'),
              ));
        }

        _isFavorite(snapshot.data.documents[item][brewName]);
        return Scaffold(
          appBar: AppBar(
            //title: Text(widget.event.data[brewName], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
            title: Text("${snapshot.data.documents[item][brewName]}"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              errorWidget(),
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                    fadeInCurve: Curves.bounceInOut,
                    imageUrl: snapshot.data.documents[item]['imageUri'] ?? '',
                    width: 100.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data.documents[item][brewName],
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
                            'Cerveceria ${snapshot.data.documents[item][brewName]}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            maxLines: 5,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            snapshot.data.documents[item]['description'],
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
                                  snapshot.data.documents[item]['phone'],
                                  "${snapshot.data.documents[item][brewName]}\nMe gustaría comprar una cerveza\n[CraftBeer Colombia]");
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
                              bloc.changeFavorite(isFavorite,
                                  snapshot.data.documents[item][brewName]);
                              setState(() {
                                isFavorite = !isFavorite;
                              });
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
              titleView('Nuestras Cervezas', color: Colors.black, size: 40.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.documents[item][brewsReleases].length,
                    (index) => GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => BeerDetailDialog(
                            title: snapshot.data.documents[item][brewsReleases]
                                [index][brewName],
                            description: "Es una cerveza",
                            buttonText: "Cerrar",
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                BeerIcon.beerglass,
                                size: 60.0,
                                color: bloc.fetchBeerColor(
                                    snapshot.data.documents[item][brewsReleases]
                                            [index][brewName] ??
                                        ''),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    'IBU: ${snapshot.data.documents[item][brewsReleases][index][ibu] ?? ''}',
                                    style: TextStyle(fontSize: 9.0),
                                  ),
                                  Text(
                                    'ABV: ${snapshot.data.documents[item][brewsReleases][index][abv] ?? ''}',
                                    style: TextStyle(fontSize: 9.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                              '${snapshot.data.documents[item][brewsReleases][index][brewName]}'),
                        ],
                      ),
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
