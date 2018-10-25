import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

import '../Rest/Response/Events.dart';
import '../brewers_detail.dart';
import '../awesome_cards.dart';
import './beer_types.dart';
import '../utils.dart';

class Home extends StatelessWidget {
  final List<Events> events = [
    Events('Donde Ñisqui', 'Toma cervecera por el moli', '',
        'https://t3.ftcdn.net/jpg/00/64/77/16/240_F_64771693_ncondhOJwNdvLjBfeIwswLqhsavUSSY5.jpg'),
    Events('Donde Ñisqui 2', 'Toma cervecera por el burro', '',
        'https://t3.ftcdn.net/jpg/00/64/77/16/240_F_64771693_ncondhOJwNdvLjBfeIwswLqhsavUSSY5.jpg'),
    Events('Donde Ñisqui 3', 'Toma cervecera por el Alfred', '',
        'https://t3.ftcdn.net/jpg/00/64/77/16/240_F_64771693_ncondhOJwNdvLjBfeIwswLqhsavUSSY5.jpg'),
    Events('Donde Ñisqui 4', 'Toma cervecera por el Gino', '',
        'https://t3.ftcdn.net/jpg/00/64/77/16/240_F_64771693_ncondhOJwNdvLjBfeIwswLqhsavUSSY5.jpg'),
    Events('Donde Ñisqui 5', 'Toma cervecera por el Enzo', '',
        'https://t3.ftcdn.net/jpg/00/64/77/16/240_F_64771693_ncondhOJwNdvLjBfeIwswLqhsavUSSY5.jpg')
  ];

  @override
  Widget build(BuildContext context) {
    return _content(events);
  }
}

Widget _content(List<Events> events) {
  return Container(
      child: ListView(
        padding: EdgeInsets.all(2.0),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Image.network('https://www.tolimafm.com/wp-content/uploads/2018/08/invima.png', height: 100.0,),
          Utils('Promociones', Colors.white, 50.0),
          _buildPromotionsCards(),
          Utils('Cervecerias Locales', Colors.white, 50.0),
          _buildBrewersCarousel(),
          Utils('Eventos Locales', Colors.white, 50.0),
          _buildEventsCards(events),
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
        if (!snapshot.hasData) {
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
  return AwesomeCards(1);
}

Widget _buildCarouselItem(DocumentSnapshot event) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Container(
        child: Card(
          child: Image.network(
            event.data['imageUri'],
          ),
          elevation: 4.0,
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
          ),
        ])),
  );
}

class ScrollViewWithHeight extends StatelessWidget {
  final Widget child;

  const ScrollViewWithHeight({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return new SingleChildScrollView(
        child: new ConstrainedBox(
          constraints: constraints.copyWith(
              minHeight: constraints.maxHeight, maxHeight: double.infinity),
          child: child,
        ),
      );
    });
  }
}
