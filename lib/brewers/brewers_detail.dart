import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
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
  bool _showBeerDescription = false;
  final String brewerRef;
  BrewerBloc bloc;
  BrewersDetailState({this.brewerRef});

  @override
  void initState() {
    super.initState();
    bloc = BrewerBloc(brewerRef: brewerRef);
    //_isFavorite(bloc.getBrewerName(snapshot));
  }

  _isFavorite(String brewerName) async {
    await bloc.isFavorite(brewerName).then((value) {
      setState(() {
        isFavorite = value;
      });
    });
  }

  _changeVisibilityBeerDesc() {
    setState(() {
      _showBeerDescription = !_showBeerDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    initInternetValidation();

    return Scaffold(
      body: StreamBuilder(
        stream: bloc.fetchBrewer(),
        builder: (context, snapshot) {
          /*debugPrint('Brewer data: ${snapshot.data['name']}');
          return Container(
              child: Center(
            child: Text('snapshot There are no brewers loading...'),
          ));*/
          if (!snapshot.hasData) {
            return Container(
                child: Center(
              child: Text('There are no brewers loading...'),
            ));
          }

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
                            CachedNetworkImage(
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
                            FlatButton.icon(
                              onPressed: () {
                                bloc.changeFavorite(
                                    isFavorite, bloc.getBrewerName(snapshot));
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
                              label: Text(''),
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
                          BeersWidget(
                              beers: snapshot.data['beers'],
                              bloc: bloc,
                              changeBeerDescriptionVisibility:
                                  _changeVisibilityBeerDesc),
                          Visibility(
                            visible: _showBeerDescription,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40.0,
                                ),
                                FlatButton(
                                  onPressed: _changeVisibilityBeerDesc,
                                  color: Colors.grey[200],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Stoud Imperial',
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              fontFamily: 'Patua'),
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
                                  'Esta cerveza se elaboraba principalmente para ser enviada a Rusia, más específicamente a la corte del Zar donde se apreciaban las cervezas oscuras y amargas. La mayor graduación alcohólica evitaba que la cerveza se congelara en el largo viaje a través del frío clima ruso mientras que el lúpulo adicional actuaba como conservante.',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      letterSpacing: 2.0,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
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

class BeersWidget extends StatelessWidget {
  final List<dynamic> beers;
  final VoidCallback changeBeerDescriptionVisibility;
  final BrewerBloc bloc;
  BeersWidget({this.beers, this.bloc, this.changeBeerDescriptionVisibility});

  changeState() {
    changeBeerDescriptionVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
                            changeState();
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
                  beerPropertiesText('IBU', '10'),
                  beerPropertiesText('ABV', '5'),
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
    );
  }
}

Widget beerPropertiesText(String propertyName, String value) {
  return Visibility(
    visible: value != null,
    child: Text(
      propertyName + value, //'IBU: ${bloc.getBeerName(snapshot)}',
      style: TextStyle(fontSize: 9.0),
    ),
  );
}
