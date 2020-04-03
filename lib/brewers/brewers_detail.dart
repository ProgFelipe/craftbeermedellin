import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/brewers/main_bloc.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
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

    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance.collection(apiRoot).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                child: Center(
              child: Text('There are no brewers loading...'),
            ));
          }

          _isFavorite(snapshot.data.documents[item][brewName]);
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                internetErrorWidget(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0)),
                      color: Colors.black54),
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
                              imageUrl: snapshot.data.documents[item]
                                      ['imageUri'] ??
                                  '',
                              width: 120.0,
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
                                  '${snapshot.data.documents[item][brewName]}',
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  snapshot.data.documents[item]['description'],
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
                                        builder: (BuildContext context) => _beerDialog(
                                            'Oscar',
                                            "Soy un emprendedor con basta certificación internacional. Ganador de varios premios locales y nacionales.",
                                            'https://d1ynl4hb5mx7r8.cloudfront.net/wp-content/uploads/2018/10/26174056/bonfire-head-brewer.jpg',
                                            brandImage: snapshot.data
                                                .documents[item]['imageUri']));
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
                          GridView.count(
                            crossAxisCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: List.generate(
                              snapshot
                                  .data.documents[item][brewsReleases].length,
                              (index) => GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => _beerDialog(
                                          snapshot.data.documents[item]
                                              [brewsReleases][index][brewName],
                                          "${snapshot.data.documents[item][brewsReleases][index][brewName]} esta cerveza fue creada con un toque amargo y jengibre ideal para el clima",
                                          'https://images.rappi.com.mx/products/976764882-1574446494426.png?d=200x200'));
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
                                              snapshot.data.documents[item]
                                                          [brewsReleases][index]
                                                      [brewName] ??
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
                          titleView('Stoud Imperial',
                              color: Colors.black, size: 25.0, padding: 0.0),
                          Text(
                            'Esta cerveza se elaboraba principalmente para ser enviada a Rusia, más específicamente a la corte del Zar donde se apreciaban las cervezas oscuras y amargas. La mayor graduación alcohólica evitaba que la cerveza se congelara en el largo viaje a través del frío clima ruso mientras que el lúpulo adicional actuaba como conservante.',
                            style: TextStyle(
                                fontSize: 16.0,
                                letterSpacing: 2.0,
                                color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/instagram.png',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                              FlatButton(
                                onPressed: () {},
                                child: Image.asset(
                                  'assets/facebook.png',
                                  width: 40.0,
                                  height: 40.0,
                                ),
                              ),
                              FlatButton(
                                onPressed: () {},
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

Widget _beerDialog(String title, String description, String imageUri,
    {String brandImage}) {
  if (brandImage != null) {
    return BeerDetailDialog(
        title: title,
        description: description,
        buttonText: "Volver",
        brandImage: Image.network(imageUri),
        circleAvatar: CircleAvatar(
          child: Image.network(brandImage),
          backgroundColor: Colors.orangeAccent[200],
          radius: Consts.avatarRadius,
        ));
  } else {
    return BeerDetailDialog(
        title: title,
        description: description,
        buttonText: "Volver",
        circleAvatar: CircleAvatar(
          child: Image.network(imageUri),
          backgroundColor: Colors.orangeAccent[200],
          radius: Consts.avatarRadius,
        ));
  }
}

Widget beerDetail() {}
