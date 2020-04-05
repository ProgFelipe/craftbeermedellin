import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

const List<String> beerFavorites = [
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol',
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol'
];

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('beertypes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 120.0,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) => Container(
                  height: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [Colors.black54, Colors.indigo],
                    ),
                  ),
                  child: FlatButton(
                    onPressed: () {
                      //TODO Show brewers with current beer type
                      /*Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => BrewersDetail(index)));*/
                    },
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 1500),
                      imageUrl:
                          snapshot.data.documents[index].data['imageUri'] ?? '',
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) => Image.network(url),
                      errorWidget: (context, url, error) => Text(
                        snapshot.data.documents[index].data['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.white,
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: List.generate(
                  5,
                  (index) => Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(90.0),
                      ),
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
