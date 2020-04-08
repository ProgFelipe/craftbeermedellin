import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/brewers/brewer_beers.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BrewersDetail extends StatelessWidget {
  final Brewer brewer;
  final String brewerRef;

  BrewersDetail({this.brewer, this.brewerRef});

  final DataBaseService db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    if (brewer == null && brewerRef != null) {
      return StreamProvider.value(
          value: db.streamBrewerByRef(brewerRef),
          child: Consumer<Brewer>(
            builder: (context, brewerModel, child) {
              if (brewerModel == null) {
                return LoadingWidget();
              } else {
                return BrewerViewBody(brewerModel);
              }
            },
          ));
    } else if (brewer != null) {
      return BrewerViewBody(brewer);
    } else {
      return LoadingWidget();
    }
  }
}

class BrewerViewBody extends StatefulWidget {
  final Brewer brewer;
  BrewerViewBody(this.brewer);

  @override
  _BrewerViewBodyState createState() => _BrewerViewBodyState(brewer);
}

class _BrewerViewBodyState extends State<BrewerViewBody> {
  final Brewer brewer;
  _BrewerViewBodyState(this.brewer);

  bool isFavorite;

  final DataBaseService db = DataBaseService();

  @override
  void initState() {
    super.initState();
    isFavorite = false;
  }

  Future<void> _isFavorite(String brewerName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFavorite =
        (prefs.getStringList('favorites') ?? List()).contains(brewerName);
  }

  void openWhatsApp() async {
    String message =
        "${brewer.name}\nMe gustaría comprar una cerveza\n[CraftBeer Colombia]";
    String url = 'whatsapp://send?phone=${brewer.phone}&text=$message';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void changeFavorite() async {
    String brewerName = brewer.name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites?.contains(brewerName);
    debugPrint('Exist $brewerName: $exist ?. New Value $isFavorite');

    if (exist && isFavorite) {
      favorites.remove(brewerName);
    }
    if (!exist && !isFavorite) {
      favorites.add(brewerName);
    }

    debugPrint('Favorites: $favorites ?.');
    await prefs.setStringList('favorites', favorites);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  showBrewerMoreInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => BeerDetailDialog(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, isFavorite);
          return Future(() => true);
        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConnectivityWidget(),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/brewerblur.png'),
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
                          ImageProviderWidget(brewer.imageUri, width: 120.0),
                          FutureBuilder(
                            future: _isFavorite(brewer.name),
                            builder: (context, snapshot) {
                              return FlatButton.icon(
                                onPressed: changeFavorite,
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
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                brewer.description,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                maxLines: 10,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              FlatButton.icon(
                                color: Colors.black54,
                                onPressed: showBrewerMoreInfo,
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
                              Visibility(
                                visible: brewer.phone.isNotEmpty,
                                child: FlatButton.icon(
                                  color: Colors.green,
                                  onPressed: () => openWhatsApp,
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
                            color: Colors.black, size: 30.0, padding: 0.0),
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
