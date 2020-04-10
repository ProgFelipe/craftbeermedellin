import 'package:craftbeer/brewers/brewer_beers.dart';
import 'package:craftbeer/brewers/offers.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
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
    var brewers = Provider.of<List<Brewer>>(context);

    if (brewer == null && brewerRef != null) {
      return FutureBuilder(
          future: db.futureBrewerByRef(brewers, brewerRef),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BrewerViewBody(snapshot.data);
            } else {
              return LoadingWidget();
            }
          });
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

  void openWhatsApp() {
    String message =
        "${brewer.name}\n${S.of(context).i_would_like_to_to_buy_msg}";
    FlutterOpenWhatsapp.sendSingleMessage(brewer.phone, message);
    //String url = 'whatsapp://send?phone=${brewer.phone}&text=$message';
    /*if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/
  }

  void changeFavorite() async {
    String brewerName = brewer.name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? List());
    bool exist = favorites?.contains(brewerName);

    if (exist && isFavorite) {
      favorites.remove(brewerName);
    }
    if (!exist && !isFavorite) {
      favorites.add(brewerName);
    }

    await prefs.setStringList('favorites', favorites);

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  showBrewerMoreInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => BeerDetailDialog(
        title: brewer.brewers,
        description: brewer.aboutUs,
        buttonText: S.of(context).back,
        avatarImage: brewer.brewersImageUri,
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: 30.0,
                          ),
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
                                height: 20.0,
                              ),
                              Text(
                                brewer.name,
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
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
                                    text: S.of(context).know_us,
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: brewer.phone.isNotEmpty,
                                child: FlatButton.icon(
                                  color: Colors.green,
                                  onPressed: openWhatsApp,
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  label: RichText(
                                    text: TextSpan(
                                      text: S
                                          .of(context)
                                          .request_beer_by_whatsapp,
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
                        titleView(S.of(context).offers,
                            color: Colors.black, size: 30.0, padding: 0.0),
                        Offers(),
                        titleView(S.of(context).our_beers,
                            color: Colors.black, size: 30.0, padding: 0.0),
                        BrewerBeersWidget(beersIds: brewer.beersRef),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Visibility(
                              visible: brewer.instagram.isNotEmpty,
                              child: FlatButton(
                                onPressed: () {
                                  _launchInBrowser(brewer.instagram);
                                },
                                child: Image.asset(
                                  'assets/instagram.png',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: brewer.facebook.isNotEmpty,
                              child: FlatButton(
                                onPressed: () {
                                  _launchInBrowser(brewer.facebook);
                                },
                                child: Image.asset(
                                  'assets/facebook.png',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: brewer.youtube.isNotEmpty,
                              child: FlatButton(
                                onPressed: () {
                                  _launchInBrowser(brewer.youtube);
                                },
                                child: Image.asset(
                                  'assets/youtube.png',
                                  width: 40.0,
                                  height: 40.0,
                                ),
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
