import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/components/decoration_constants.dart';
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
              ConnectivityWidget(),
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
    shape: cardDecoration(),
    elevation: 0.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DecorationConsts.cardRadius),
                topRight: Radius.circular(DecorationConsts.cardRadius)),
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.date_range, color: Colors.grey),
            Text(
              event['date'] != null ? '${event['date']}' : '',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        cardTitle(event['name']),
        cardTitle(event['city']),
        Center(child: _buildTimerButton()),
        SizedBox(
          height: 10.0,
        )
        //cardTitle(event['description']),
      ],
    ),
  );
}

Widget _buildTimerButton() {
  return Container(
      alignment: Alignment.center,
      width: 130.0,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue),
          borderRadius: new BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.access_time,
            color: Colors.blue,
          ),
          Text(
            '8 hours 20 min',
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.blue,
            ),
          ),
        ],
      ));
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
                    return Card(
                        shape: cardDecoration(),
                        elevation: 3.0,
                        color: Colors.white,
                        semanticContainer: true,
                        child: Image.network(
                            snapshot.data.documents[index]['imageUri'] ??
                                'http://morganfields.com.sg/wp-content/uploads/img-home-promo3.jpg',
                            width: 100.0,
                            fit: BoxFit.cover));
                  }));
        } else {
          return Text('No hay promociones');
        }
      });
}
