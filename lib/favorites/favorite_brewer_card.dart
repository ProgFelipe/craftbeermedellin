import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCard extends StatelessWidget {
  final String brewerId;
  FavoriteCard({this.brewerId});

  @override
  Widget build(BuildContext context) {
    debugPrint('Brewer id $brewerId');
    List<Brewer> brewers = Provider.of<List<Brewer>>(context);
    brewers.forEach((element) {
      debugPrint('Brewer id ${element.id}');
    });
    Brewer brewer = brewers.where((element) => element.name == brewerId).first;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Card(
        color: Colors.white,
        elevation: 20.0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.network(
                  brewer.imageUri,
                  fit: BoxFit.scaleDown,
                  height: 200.0,
                  width: 180.0,
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                    height: 200.0,
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          brewer.name,
                          style: TextStyle(fontFamily: 'Patua', fontSize: 30.0),
                        ),
                        Text(
                          brewer.description,
                          overflow: TextOverflow.fade,
                          maxLines: 20,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.orangeAccent,
                              fontFamily: 'Patua',
                              fontSize: 12.0),
                        ),
                        /*Text(snapshot.data['location'] ?? '',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Patua',
                                fontSize: 14.0)),*/
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
StreamBuilder(
        stream: db.fetchBrewerByName(brewerId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            debugPrint('BREWER $brewerId');
            debugPrint('BREWER ${snapshot.data.documents[0]}');
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Card(
                color: Colors.white,
                elevation: 20.0,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          snapshot.data['name'],
                          fit: BoxFit.scaleDown,
                          height: 200.0,
                          width: 180.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            height: 200.0,
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data[0]['name'],
                                  style: TextStyle(
                                      fontFamily: 'Patua', fontSize: 30.0),
                                ),
                                Text(
                                  snapshot.data['description'],
                                  overflow: TextOverflow.fade,
                                  maxLines: 20,
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontFamily: 'Patua',
                                      fontSize: 12.0),
                                ),
                                Text(snapshot.data['location'] ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Patua',
                                        fontSize: 14.0)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        });
 */
