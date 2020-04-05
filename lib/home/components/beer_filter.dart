import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  String _beerTypeRef;

  changeBeerTypeSelection(String beerTypeSelected) {
    setState(() {
      debugPrint('New documentID $beerTypeSelected');
      _beerTypeRef = beerTypeSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BeerType> categories = Provider.of<List<BeerType>>(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(),
      child: Column(
        children: <Widget>[
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(
              categories.length,
              (index) => GestureDetector(
                onTap: () => changeBeerTypeSelection(categories[index].name),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [Colors.black54, Colors.indigo],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CachedNetworkImage(
                        height: 60.0,
                        fadeInDuration: Duration(milliseconds: 1500),
                        imageUrl: categories[index].imageUri,
                        fit: BoxFit.scaleDown,
                        placeholder: (context, url) => Image.network(url),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 60.0,
                        ),
                      ),
                      Text(
                        categories[index].name,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          FilterBeersByTypeView(beerType: _beerTypeRef),
        ],
      ),
    );
    /*StreamBuilder(
        stream: Firestore.instance.collection('beertypes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(),
              child: Column(
                children: <Widget>[
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    children: List.generate(
                      snapshot.data.documents.length,
                      (index) => GestureDetector(
                        onTap: () => changeBeerTypeSelection(
                            snapshot.data.documents[index].documentID),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                              colors: [Colors.black54, Colors.indigo],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CachedNetworkImage(
                                height: 60.0,
                                fadeInDuration: Duration(milliseconds: 1500),
                                imageUrl: snapshot.data.documents[index]
                                        .data['imageUri'] ??
                                    '',
                                fit: BoxFit.scaleDown,
                                placeholder: (context, url) =>
                                    Image.network(url),
                                errorWidget: (context, url, error) => SizedBox(
                                  height: 60.0,
                                ),
                              ),
                              Text(
                                snapshot.data.documents[index].data['name'],
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  FilterBeersByTypeView(beerType: _beerTypeRef),
                ],
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
        });*/
  }
}
/*
              ListView.builder(
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
                    child: Text(snapshot.data.documents[index].data['name']),
                    /*CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 1500),
                      imageUrl:
                          snapshot.data.documents[index].data['imageUri'] ?? '',
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) => Image.network(url),
                      errorWidget: (context, url, error) => Text(
                        snapshot.data.documents[index].data['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),*/
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
 */

class FilterBeersByTypeView extends StatelessWidget {
  final String beerType;
  FilterBeersByTypeView({this.beerType});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: beerType != null
            ? StreamBuilder(
                stream: db.fetchBeersByType(beerType),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    debugPrint('Result filter ${snapshot.data.documents}');
                    return Row(
                        children: List.generate(
                            snapshot.data.documents.length,
                            (index) => beerByTypeItem(
                                snapshot.data.documents[index], context)));
                  } else {
                    return SizedBox(
                      height: 10.0,
                    );
                  }
                },
              )
            : Container());
  }
}

Widget beerByTypeItem(DocumentSnapshot beerSnapshot, context) {
  return GestureDetector(
    onTap: () {
      //Go to brewer
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              BrewersDetail(beerSnapshot.data['brewer'].documentID)));
    },
    child: Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Card(
            child: CachedNetworkImage(
              height: 90.0,
              fadeInDuration: Duration(milliseconds: 1500),
              imageUrl: beerSnapshot.data['imageUri'] ?? '',
              fit: BoxFit.scaleDown,
              placeholder: (context, url) => Image.network(
                url,
                height: 90.0,
              ),
              errorWidget: (context, url, error) => Image.asset(
                'assets/beer.png',
                height: 90.0,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          left: 10.0,
          child: Text(
            beerSnapshot.data['name'],
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white30),
          ),
        )
      ],
    ),
  );
}
