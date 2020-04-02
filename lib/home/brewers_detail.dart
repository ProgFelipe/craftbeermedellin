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
                leading: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    BeerIcon.beerglass,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Center(
                child: Text('There are no brewers loading...'),
              ));
        }

        _isFavorite(snapshot.data.documents[item][brewName]);
        return Scaffold(
          appBar: AppBar(
            //title: Text(widget.event.data[brewName], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
            centerTitle: true,
            title: Text("${snapshot.data.documents[item][brewName]}"),
            leading: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                BeerIcon.beerglass,
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              errorWidget(),
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () {
                          bloc.changeFavorite(isFavorite,
                              snapshot.data.documents[item][brewName]);
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 40.0,
                          color: Colors.red,
                        ),
                        label: Text(''),
                      ),
                      CachedNetworkImage(
                        fadeInCurve: Curves.bounceInOut,
                        imageUrl:
                            snapshot.data.documents[item]['imageUri'] ?? '',
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
                            color: Colors.black54,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    BeerDetailDialog(
                                  title: 'Oscar',
                                  brewerImage: Image.network(
                                      'https://d1ynl4hb5mx7r8.cloudfront.net/wp-content/uploads/2018/10/26174056/bonfire-head-brewer.jpg'),
                                  brandImage: Image.network(snapshot
                                      .data.documents[item]['imageUri']),
                                  description:
                                      "Soy un emprendedor con basta certificación internacional. Ganador de varios premios locales y nacionales.",
                                  buttonText: "Volver",
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
                              title: snapshot.data.documents[item]
                                  [brewsReleases][index][brewName],
                              description:
                                  "${snapshot.data.documents[item][brewsReleases][index][brewName]} esta cerveza fue creada con un toque amargo y jengibre ideal para el clima",
                              buttonText: "Volver",
                              circleAvatar: CircleAvatar(
                                child: Image.network(
                                    'https://images.rappi.com.mx/products/976764882-1574446494426.png?d=200x200'),
                                backgroundColor: Colors.orangeAccent[200],
                                radius: Consts.avatarRadius,
                              )),
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
            ],
          ),
        );
      },
    );
  }
}
