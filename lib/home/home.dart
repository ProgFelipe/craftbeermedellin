import 'package:craftbeer/api/brewer_events.dart';
import 'package:craftbeer/brewers_detail.dart';
import 'package:craftbeer/components/awesome_cards.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../utils.dart';
import './beer_types.dart';
import '../base_view.dart';
import '../Events/event_detail.dart';

class Home extends BaseView {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends BaseViewState {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<BrewEvents> events = [
    BrewEvents('Donde Ñisqui', 'Toma cervecera por el moli', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    BrewEvents('Donde Ñisqui 2', 'Toma cervecera por el burro', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    BrewEvents('Donde Ñisqui 3', 'Toma cervecera por el Alfred', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    BrewEvents('Donde Ñisqui 4', 'Toma cervecera por el Gino', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    BrewEvents('Donde Ñisqui 5', 'Toma cervecera por el Enzo', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    if (connectionStatus == 'ConnectivityResult.none') {
      return Center(child: Text('Connection Status: $connectionStatus\n'));
      //return _content(events, internet: false);
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: Firestore.instance.collection('brewers').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('There are no brewers loading...'),
                );
              } else {
                if (snapshot.hasData) {
                  return _homeContent(events);
                } else {
                  return Center(
                    child: Text('No encontramos información...'),
                  );
                }
              }
            },
          ),
        ),
      );
    }
  }
}

Widget _homeContent(List<BrewEvents> events) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Image.asset(
            'assets/icon.png',
            alignment: Alignment.center,
            height: 100.0,
          ),
        ),
        Column(
          children: <Widget>[
            Utils('Promociones', Colors.black87, 50.0),
            _buildPromotionsCards()
          ],
        ),
        Utils('Cervecerias Locales', Colors.white, 50.0),
        _buildBrewersCarousel(),
        Utils('Eventos Locales', Colors.black87, 50.0),
        _buildEventsCards(events),
        Utils('Tipos de cervezas', Colors.white, 50.0),
        BeerTypes(),
      ],
    ),
  );
}

/* Widget _buidlWithOutInternetContent() {
  return Container(
      child: ListView(
        padding: EdgeInsets.all(2.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Text(
            'SIN INTERNET',
            style: TextStyle(
                color: Colors.redAccent[400],
                wordSpacing: 4.0,
                fontSize: 40.0,
                fontFamily: 'Future'),
            textAlign: TextAlign.center,
          ),
          Utils('Promociones', Colors.white, 50.0),
          _buildPromotionsCardsNoInternet(1),
          Utils('Cervecerias Locales', Colors.white, 50.0),
          _buildPromotionsCardsNoInternet(2),
          //_buildBrewersCarousel(),
          Utils('Eventos Locales', Colors.white, 50.0),
          //_buildEventsCards(events),
          _buildPromotionsCardsNoInternet(3),
          Utils('Tipos de cervezas', Colors.greenAccent, 50.0),
          _buildPromotionsCardsNoInternet(4),
        ],
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/beer_blur.jpg"),
        fit: BoxFit.cover,
      )));
} */

Widget _buildEventsCards(List<BrewEvents> events) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildEvents(events[index], context);
          }));
}

Widget _buildPromotionsCards() {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return AwesomeCards(2);
          }));
}

Widget _buildBrewersCarousel() {
  return Container(
    margin: EdgeInsets.only(bottom: 20.0),
    height: 200.0,
    child: StreamBuilder(
      stream: Firestore.instance.collection('brewers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text('There are no brewers loading...');
        }
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 2.0),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              var child;
              child = _buildCarouselItem(snapshot.data.documents[index]);
              return GestureDetector(
                  child: child,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BrewersDetail(index))));
            });
      },
    ),
  );
}

Widget _buildEvents(BrewEvents event, BuildContext context) {
  return GestureDetector(
      child: _buildCustomCard(event.imageUri),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => EventsDetail())));
}

Widget _buildCarouselItem(DocumentSnapshot event) {
  return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
          child: Card(
            child: _buildCustomCard(event.data['imageUri']),
          ),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
            ),
          ])));
}

Widget _buildCustomCard(String url) {
  return Card(
      child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: Card(
                  elevation: 4.0,
                  child: Container(
                    width: 150.0,
                    height: 48.0,
                    color: Colors.white,
                  ))),
          errorWidget: (context, url, error) => Card(
              elevation: 4.0,
              child: Container(
                width: 150.0,
                height: 48.0,
                color: Colors.white,
                child: Icon(Icons.error),
              ))));
}

class LoadingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: [0, 1, 2, 3, 4, 5, 6]
                .map((_) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48.0,
                            height: 48.0,
                            color: Colors.green,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.yellow,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: 40.0,
                                  height: 8.0,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
