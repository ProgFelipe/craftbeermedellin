import 'dart:ui';
import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  List<String> _beersRef;

  changeBeerTypeSelection(List<String> beerTypeSelected) {
    setState(() {
      debugPrint('New documentID $beerTypeSelected');
      if (beerTypeSelected.length == 0) {
        _beersRef = null;
      } else {
        _beersRef = beerTypeSelected;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _beersRef = null;
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
                onTap: () {
                  changeBeerTypeSelection(categories[index]?.beers);
                },
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
          FilterBeersByTypeView(beersRef: _beersRef),
        ],
      ),
    );
  }
}

class FilterBeersByTypeView extends StatelessWidget {
  final List<String> beersRef;
  final db = DataBaseService();
  FilterBeersByTypeView({this.beersRef});

  @override
  Widget build(BuildContext context) {
    if (beersRef == null || beersRef.isEmpty) {
      return Text('EMPTY');
    }
    return Container(
      decoration: BoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: List.generate(
          beersRef?.length ?? 0,
          (index) => StreamProvider<Beer>.value(
            value: db.streamBeerByType(beersRef[index]),
            child: Consumer<Beer>(
              //                    <--- Consumer
              builder: (context, myModel, child) {
                if (myModel == null) return SizedBox();
                return BeerItem();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BeerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var beer = Provider.of<Beer>(context);

    return GestureDetector(
      onTap: () {
        //Go to brewer
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BrewersDetail(beer.id)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Card(
              child: CachedNetworkImage(
                height: 90.0,
                fadeInDuration: Duration(milliseconds: 1500),
                imageUrl: beer.imageUri,
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
              beer.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white30),
            ),
          )
        ],
      ),
    );
  }
}
