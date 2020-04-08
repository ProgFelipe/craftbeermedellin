import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/home/new_releases.dart';
import 'package:craftbeer/home/top_beers.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/home/search_view.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: Colors.black87,
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ConnectivityWidget(),
              BeerReleases(),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Image.asset(
                  'assets/icon.png',
                  alignment: Alignment.center,
                  height: 100.0,
                ),
              ),
              //storyTellingWidget(context),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: 40.0, left: 20.0, right: 20.0),
                  child: SearchWidget()),
              titleView('Top Week Selections'),
              TopBeersView(),
              titleView(localizedText(context, LOCAL_BREWERS_TITLE)),
              BrewersGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _brewersDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(90.0),
    ),
    gradient: LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: [Colors.black, Colors.white.withOpacity(0.4)],
    ),
  );
}

class BrewersGrid extends StatefulWidget {
  @override
  _BrewersGridState createState() => _BrewersGridState();
}

class _BrewersGridState extends State<BrewersGrid> {
  List<String> favorites = [];
  Future<List<String>> getFutureFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? List();
  }

  bool isFavorite(String brewer) {
    return favorites.contains(brewer);
  }

  bool favoriteOnDemand;

  @override
  Widget build(BuildContext context) {
    var brewers = Provider.of<List<Brewer>>(context);

    return FutureBuilder(
        future: getFutureFavorites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                shrinkWrap: true,
                children: List.generate(brewers?.length ?? 0, (index) {
                  return BrewerItem(brewers[index], (snapshot.data as List<String>).contains(brewers[index].name));
                }),
              ),
            );
          }
          return LoadingWidget();
        });
  }
}

class BrewerItem extends StatefulWidget {
  final Brewer brewer;
  final bool isFavorite;
  BrewerItem(this.brewer, this.isFavorite);
  @override
  _BrewerItemState createState() => _BrewerItemState(brewer, isFavorite);
}

class _BrewerItemState extends State<BrewerItem> {
  final Brewer brewer;
  bool isFavorite;
  _BrewerItemState(this.brewer, this.isFavorite);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrewersDetail(
                brewer: brewer,
              )),
        );
        if(result != null) {
          setState(() {
            isFavorite = result;
          });
        }
      },
      child: Container(
        decoration: _brewersDecoration(),
        margin: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            ImageProviderWidget(brewer.imageUri),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 40.0,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
