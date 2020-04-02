import 'package:flutter/material.dart';

class AwesomeCards extends StatelessWidget {
  int type;
  String url;
  AwesomeCards(this.type, this.url);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 1:
        return _tempCard();
        break;
      case 2:
        return _newsCard(url);
        break;
      default:
        return _newsCard(url);
        break;
    }
  }

  Widget _newsCard(String url) {
    return Card(
        elevation: 3.0,
        color: Colors.white,
        semanticContainer: true,
        child: Image.network(
            url ??
                'http://morganfields.com.sg/wp-content/uploads/img-home-promo3.jpg',
            width: 100.0,
            fit: BoxFit.cover));
  }

  Widget _tempCard() {
    return Container(
      height: 200.0,
      margin: EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
          elevation: 5.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'event.title',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.pinkAccent,
                      fontSize: 22.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  '23 de Diciembre',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 22.0),
                ),
              ),
              Text(
                'event.description',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          )),
    );
  }
}
