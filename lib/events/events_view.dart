import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/components/awesome_cards.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key key}) : super(key: key);

  Stream fetchEvents() {
    debugPrint('Fetching Events...');
    return db.fetchEvents();
  }

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
              _buildPromotionsCards(context),
              titleView('Eventos Locales'),
              StreamBuilder(
                stream: fetchEvents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _eventCard(snapshot.data.documents[index]),
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(2),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
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

Widget _eventCard(DocumentSnapshot event) {
  return Card(
    child: Column(
      children: <Widget>[
        _emptyOrNullSafetyText(event['name']),
        _emptyOrNullSafetyText(event['city']),
        SizedBox(
          height: 10.0,
        ),
        _emptyOrNullSafetyText(event['description']),
        event['date'] != null
            ? ListTile(
                leading: Icon(Icons.date_range),
                title: Text('${event['date']}'),
              )
            : SizedBox(),
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
  );
}

Widget _buildPromotionsCards(context) {
  Stream fetchPromotions() => db.fetchPromotions();

  return StreamBuilder(
      stream: fetchPromotions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 2.0),
              height: 200.0,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AwesomeCards(
                        2, snapshot.data.documents[index]['imageUri']);
                  }));
        } else {
          return Text('No hay promociones');
        }
      });
}

Widget _emptyOrNullSafetyText(String value) {
  if (value == null) {
    return SizedBox();
  } else {
    return Text(
      value,
      style: TextStyle(fontSize: 20.0),
      textAlign: TextAlign.center,
    );
  }
}
