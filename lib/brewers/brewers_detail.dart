import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/brewers/brewer_beers.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/brewers/brewer_bloc.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BrewersDetail extends BaseView {
  final String brewerRef;

  BrewersDetail(this.brewerRef);

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState(brewerRef: brewerRef);
  }
}

class BrewersDetailState extends BaseViewState<BrewersDetail> {
  bool isFavorite = false;
  final String brewerRef;
  BrewerBloc bloc;
  BrewersDetailState({this.brewerRef});

  @override
  void initState() {
    super.initState();
    bloc = BrewerBloc(brewerRef: brewerRef);
  }

  Future<bool> _isFavorite(String brewerName) async {
    bool result = await bloc.isFavorite(brewerName);
    return result;
  }

  String brewerName = '';
  void changeFavoriteState() {
    debugPrint('BrewerName => $brewerName');

    bloc.changeFavorite(!isFavorite, brewerName);
    setState(() {
      isFavorite = !isFavorite;
      debugPrint('Is Favorite? => $isFavorite');
    });
  }

  @override
  Widget build(BuildContext context) {
    initInternetValidation();

    return Scaffold(
      body: StreamBuilder(
        stream: bloc.fetchBrewer(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                child: Center(
              child: Text('There are no brewers loading...'),
            ));
          }

          brewerName = bloc.getBrewerName(snapshot);
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                internetErrorWidget(),
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
                            Hero(
                              tag: brewerRef,
                              child: CachedNetworkImage(
                                fadeInCurve: Curves.bounceInOut,
                                imageUrl: bloc.getLogo(snapshot) ?? '',
                                width: 120.0,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        bloc.getBrewerName(snapshot),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Container(
                                        child: Icon(Icons.error),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            FutureBuilder(
                              future: _isFavorite(bloc.getBrewerName(snapshot)),
                              builder: (context, snapshot) {
                                isFavorite = snapshot.data;
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
                            )
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
                                  '${bloc.getBrewerName(snapshot)}',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  bloc.getBrewerDescription(snapshot),
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
                                        avatarImage: bloc.getLogo(snapshot),
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
                                        bloc.getPhone(snapshot),
                                        "${bloc.getBrewerName(snapshot)}\nMe gustaría comprar una cerveza\n[CraftBeer Colombia]");
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
                          BrewerBeers(beersIds: snapshot.data['beers']),
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
          );
        },
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
