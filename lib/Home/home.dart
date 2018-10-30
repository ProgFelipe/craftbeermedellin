import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../utils.dart';
import '../Rest/Response/Events.dart';
import '../brewers_detail.dart';
import '../awesome_cards.dart';
import './beer_types.dart';
import '../base_view.dart';
import '../Animations/animation.dart';
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

  final List<Events> events = [
    Events('Donde Ñisqui', 'Toma cervecera por el moli', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    Events('Donde Ñisqui 2', 'Toma cervecera por el burro', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    Events('Donde Ñisqui 3', 'Toma cervecera por el Alfred', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    Events('Donde Ñisqui 4', 'Toma cervecera por el Gino', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg'),
    Events('Donde Ñisqui 5', 'Toma cervecera por el Enzo', '',
        'https://s3.amazonaws.com/ft-images/shows/2b69520f4033c28c02adf7b776ff7cc9f7afba3f.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    if (connectionStatus == 'ConnectivityResult.none') {
      return Center(child: Text('Connection Status: $connectionStatus\n'));
      //return _content(events, internet: false);
    } else {
      return _content(events);
    }
  }
}

Widget _content(List<Events> events, {bool internet: true}) {
  bool contentLoaded = false;
  return Container(
      child: StreamBuilder(
          stream: Firestore.instance.collection('brewers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('There are no brewers loading...'),
              );
            } else {
              return _buildInternetContent(events);
            }
          }));
}

Widget _buildInternetContent(List<Events> events) {
  return Container(
      child: ListView(
        padding: EdgeInsets.all(2.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 2.0), child: Image.asset('assets/beer.png', alignment: Alignment.center, height: 120.0,),),
          Card(
              child: Column(
            children: <Widget>[
              Utils('Promociones', Colors.black87, 50.0),
              _buildPromotionsCards()
            ],
          ), elevation: 2.0,),
          Utils('Cervecerias Locales', Colors.white, 50.0),
          _buildBrewersCarousel(),
          Card(
            child: Column(
              children: <Widget>[
                Utils('Eventos Locales', Colors.black87, 50.0),
                _buildEventsCards(events)
              ],
            ),
            elevation: 2.0,
          ),
          Utils('Tipos de cervezas', Colors.greenAccent, 50.0),
          BeerTypes(),
        ],
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/beer_blur.jpg"),
        fit: BoxFit.cover,
      )));
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

Widget _buildEventsCards(List<Events> events) {
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

Widget _buildPromotionsCardsNoInternet(int loadingType) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            //TODO LOADING GIF
            if (loadingType == 1) {
              return Card(
                  elevation: 3.0,
                  color: Colors.white70,
                  semanticContainer: true,
                  child: Container(
                    child: EasingAnimationWidget(),
                    width: 200.0,
                    height: 100.0,
                    color: Colors.white,
                  ));
            } else {
              return Card(
                  elevation: 3.0,
                  color: Colors.white70,
                  semanticContainer: true,
                  child: Image.asset('assets/loading$loadingType.gif',
                      width: 100.0, fit: BoxFit.cover));
            }
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
    margin: EdgeInsets.symmetric(vertical: 2.0),
    height: 200.0,
    child: StreamBuilder(
      stream: Firestore.instance.collection('brewers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text('There are no brewers loading...');
        }
        return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 0.0),
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

Widget _buildEvents(Events event, BuildContext context) {
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
          placeholder: Shimmer.fromColors(
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
          errorWidget: Card(
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
