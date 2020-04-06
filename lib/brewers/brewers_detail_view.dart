import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/brewers/brewer_beers.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BrewersDetail extends StatefulWidget {
  final String brewerRef;
  final Brewer brewer;

  BrewersDetail(this.brewerRef, {this.brewer});

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState(brewerRef, brewer: brewer);
  }
}

class BrewersDetailState extends State<BrewersDetail> {
  bool isFavorite;
  final String brewerRef;
  Brewer brewer;
  final DataBaseService db = DataBaseService();
  BrewersDetailState(this.brewerRef, {this.brewer});

  @override
  void initState() {
    super.initState();
    isFavorite = false;
  }

  Future<bool> isFavoritePreference(brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('favorites') ?? List()).contains(brewerName);
  }

  Future<bool> _isFavorite(String brewerName) async {
    bool result = await isFavoritePreference(brewerName);
    return result;
  }

  String brewerName = '';
  void changeFavoriteState() {
    debugPrint('BrewerName => $brewerName');

    changeFavorite(!isFavorite, brewerName);
    setState(() {
      isFavorite = !isFavorite;
      debugPrint('Is Favorite? => $isFavorite');
    });
  }

  void changeFavorite(bool isFavorite, String brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites?.contains(brewerName);
    debugPrint('Exist: $exist ?. New Value $isFavorite');
    debugPrint('Favorites: $favorites ?.');

    if (exist || isFavorite) {
      isFavorite ? favorites.add(brewerName) : favorites.remove(brewerName);
    }
    debugPrint('Favorites: $favorites ?.');
    debugPrint('Brewer is t0 favorite: $exist ?.');
    debugPrint('Brewer is t1 favorite: $isFavorite ?.');
    await prefs.setStringList('favorites', favorites);
  }

  @override
  Widget build(BuildContext context) {
    if (brewer == null) {
      return StreamProvider<Brewer>.value(
          value: db.streamBrewerByRef(brewerRef),
          child: Consumer<Brewer>(builder: (context, brewerModel, child) {
            brewer = brewerModel;
            return Text('BEER ${brewerModel.name}]');
          }));
    }
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConnectivityWidget(),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/beer3.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0)),
              ),
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          fadeInCurve: Curves.bounceInOut,
                          imageUrl: brewer.imageUri,
                          width: 120.0,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  brewer.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Container(
                                  child: Icon(Icons.error),
                                ),
                              ],
                            );
                          },
                        ),
                        FutureBuilder(
                          future: _isFavorite(brewer.name),
                          builder: (context, snapshot) {
                            isFavorite = snapshot.data ?? false;
                            /*String brewerName =
                                        bloc.getBrewerName(snapshot);*/
                            debugPrint('Is Favorite? => $isFavorite');
                            return FlatButton.icon(
                              onPressed: changeFavoriteState,
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 40.0,
                                color: Colors.red,
                              ),
                              label: Text(''),
                            );
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              brewer.name,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              brewer.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16.0),
                              maxLines: 10,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            FlatButton.icon(
                              color: Colors.black54,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      BeerDetailDialog(
                                    title: 'Oscar',
                                    description:
                                        'Soy un emprendedor con basta certificación internacional. Ganador de varios premios locales y nacionales.',
                                    buttonText: "Volver",
                                    avatarImage: brewer.imageUri,
                                    contentImage:
                                        'https://d1ynl4hb5mx7r8.cloudfront.net/wp-content/uploads/2018/10/26174056/bonfire-head-brewer.jpg',
                                    avatarColor: Colors.orangeAccent[200],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                              ),
                              label: RichText(
                                text: TextSpan(
                                  text: 'Conocenos',
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                            FlatButton.icon(
                              color: Colors.green,
                              onPressed: () async {
                                FlutterOpenWhatsapp.sendSingleMessage(
                                    brewer.phone,
                                    "${brewer.name}\nMe gustaría comprar una cerveza\n[CraftBeer Colombia]");
                              },
                              icon: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              label: RichText(
                                text: TextSpan(
                                  text: 'Pedir Whatsapp',
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: <Widget>[
                      titleView('Nuestras Cervezas',
                          color: Colors.black, size: 40.0, padding: 0.0),
                      BrewerBeersWidget(beersIds: brewer.beersRef),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              _launchInBrowser(
                                  'https://www.instagram.com/paolagarciaolaya/');
                            },
                            child: Image.asset(
                              'assets/instagram.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              _launchInBrowser(
                                  'https://www.facebook.com/laplantamedellin/');
                            },
                            child: Image.asset(
                              'assets/facebook.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              _launchInBrowser(
                                  'https://www.youtube.com/watch?v=0dEvh3afEqE');
                            },
                            child: Image.asset(
                              'assets/youtube.png',
                              width: 40.0,
                              height: 40.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}
