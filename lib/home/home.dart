import 'package:craftbeer/base_view.dart';
import 'package:craftbeer/home/components/beer_filter.dart';
import 'package:craftbeer/brewers/brewers_detail.dart';
import 'package:craftbeer/home/components/image_error.dart';
import 'package:craftbeer/home/new_releases.dart';
import 'package:craftbeer/home/top_beers.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:craftbeer/search/search_view.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../utils.dart';

const int SHIMMER_BREWER_GRID_COUNT = 6;

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topBeers = TopBeersView();
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
                  child: SearchView()),
              titleView('Top Week Selections'),
              topBeers,
              BeerReleases(),
              titleView(localizedText(context, LOCAL_BREWERS_TITLE)),
              //brewersGrid,
              BrewersGrid(),
              //_buildEventsCards(events),
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

Widget _shimmerBrewers() {
  return Shimmer.fromColors(
    baseColor: Colors.black,
    highlightColor: Colors.white,
    child: GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(
        SHIMMER_BREWER_GRID_COUNT,
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

Widget _brewerCard(context, String url, String name, String reference) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BrewersDetail(reference)));
    },
    child: Container(
      decoration: _brewersDecoration(),
      margin: EdgeInsets.all(10.0),
      child: url != null && url.isNotEmpty
          ? CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 1500),
              imageUrl: url ?? '',
              fit: BoxFit.scaleDown,
              placeholder: (context, url) => Image.network(url),
              errorWidget: (context, url, error) => errorColumn(name),
            )
          : errorColumn(name),
    ),
  );
}

class BrewersGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brewers = Provider.of<List<Brewer>>(context);

    final brewersGrid = StreamBuilder(
      stream: db.fetchBrewers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(
                snapshot.data.documents.length,
                (index) => _brewerCard(
                    context,
                    snapshot.data.documents[index].data['imageUri'],
                    snapshot.data.documents[index].data['name'],
                    snapshot.data.documents[index].documentID),
              ),
            ),
          );
        } else {
          return _shimmerBrewers();
        }
      },
    );
    return Container(
      margin: EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        shrinkWrap: true,
        children: List.generate(
            brewers.length,
            (index) => _brewerCard(context, brewers[index].imageUri,
                brewers[index].name, brewers[index].id)),
      ),
    );
  }
}
