import 'dart:ui';

import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/category_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/models/categories_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CategoriesView extends StatefulWidget {

  final Function scrollUp;

  CategoriesView(this.scrollUp);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> with AutomaticKeepAliveClientMixin<CategoriesView> {

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
      widget.scrollUp();
      if (category != _selectedCategory) {
        _selectedCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var categoriesData = Provider.of<CategoriesData>(context);
    List<BeerType> categories = categoriesData.categories;
    List<Beer> beers = Provider.of<BrewersData>(context).beers;

    if (categories == null ||
        categories?.isEmpty == true && beers?.isEmpty == true) {
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
          GridView.builder(
            itemCount: categories.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 15.0,),
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
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FilterBeersByTypeView extends StatelessWidget {
  final BeerType category;
  final List<Beer> beers;
  final db = DataBaseService();

  FilterBeersByTypeView({this.category, this.beers});

  @override
  Widget build(BuildContext context) {
    if (category.beers?.length == 0 ?? true && beers?.length == 0 ?? true) {
      return Container(
        height: 140.0,
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
              (index) => BeerItem(category.beers[index]),
        ),
      ),);
  }
}

class BeerItem extends StatelessWidget {
  final CategoryBeer beer;

  BeerItem(this.beer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(brewerId: beer.brewerId)));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 140.0,
            width: 100.0,
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
