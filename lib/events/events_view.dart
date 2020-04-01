import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/components/awesome_cards.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [Colors.black, Colors.blueGrey],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              titleView('Promociones'),
              _buildPromotionsCards(),
              titleView('Eventos Locales'),
              StreamBuilder(
                stream: Firestore.instance.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    List<Widget> cities = List();

                    snapshot.data.documents.forEach((city) {
                      cities = _createEventsCards(city);
                    });
                    return Column(
                      children: cities,
                    );
                  } else {
                    return Container(child: Text('Cargando Eventos..'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> _createEventsCards(DocumentSnapshot city) {
  List<Widget> events = List();
  events.add(Text(
    'Ciudad ${city['name']}',
    style: TextStyle(color: Colors.white),
  ));
  city['evento'].forEach((event) {
    events.add(
      Container(
        child: Card(
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  '${event['name']}',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text('${event['description']}'),
                ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('${event['date']}'),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 1500),
                    imageUrl: event['imageUri'],
                    fit: BoxFit.scaleDown,
                    placeholder: (context, url) => Image.network(url),
                    errorWidget: (context, url, error) => Card(
                      elevation: 4.0,
                      child: Container(
                        child: Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
  return events;
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
