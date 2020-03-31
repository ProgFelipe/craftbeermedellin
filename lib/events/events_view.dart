import 'package:craftbeer/components/awesome_cards.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        children: <Widget>[
          TitleTextUtils('Promociones', Colors.white, 50.0),
          _buildPromotionsCards(),
          TitleTextUtils('Eventos Locales', Colors.white, 50.0),
        ],
      ),
    );
  }
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
