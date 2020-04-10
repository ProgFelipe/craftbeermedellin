import 'dart:ui';

import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  BeerType _selectedCategory;

  @override
  void initState() {
    debugPrint('INIT STATE CATEGORIES');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('DISPOSE STATE CATEGORIES');
    super.dispose();
  }

  changeBeerTypeSelection(BeerType category) {
    setState(() {
      if (category != _selectedCategory) {
        _selectedCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BeerType> categories = Provider.of<List<BeerType>>(context);
    List<Beer> beers = Provider.of<List<Beer>>(context);

    if (categories?.isEmpty == true && beers?.isEmpty == true) {
      return LoadingWidget();
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(),
      child: Column(
        children: <Widget>[
          _selectedCategory != null
              ? FilterBeersByTypeView(category: _selectedCategory, beers: beers)
              : SizedBox(
                  height: 0.0,
                ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(
              categories?.length ?? 0,
              (index) => GestureDetector(
                onTap: () {
                  changeBeerTypeSelection(categories[index]);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
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
                          Expanded(
                              child: ImageProviderWidget(
                            categories[index].imageUri,
                            height: 60.0,
                          )),
                          Text(
                            categories[index].name,
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 10.0,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.orangeAccent),
                        child: Text(
                          '${categories[index].beers.length}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      top: 0.0,
                      right: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBeersByTypeView extends StatelessWidget {
  final BeerType category;
  List<Beer> beers;
  final db = DataBaseService();

  FilterBeersByTypeView({this.category, this.beers});

  @override
  Widget build(BuildContext context) {
    if (category.beers?.length == 0 ?? true && beers?.length == 0 ?? true) {
      return Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Center(
            child: Icon(
          Icons.all_inclusive,
          size: 40.0,
        )),
      );
    }
    return Container(
      decoration: BoxDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: List.generate(
          category.beers?.length ?? 0,
          (index) => FutureBuilder(
              future: db.futureBeerByReference(beers, category.beers[index]),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BeerItem(snapshot.data);
                }
                return Text('');
              }),
        ),
      ),
    );
  }
}

class BeerItem extends StatelessWidget {
  final Beer beer;

  BeerItem(this.beer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(brewerRef: beer.brewerRef)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Card(
                child: ImageProviderWidget(
              beer.imageUri,
              height: 90.0,
            )),
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
