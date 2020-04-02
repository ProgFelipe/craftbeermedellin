import 'package:craftbeer/components/beer_filter.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/home/brewers_detail.dart';
import 'package:craftbeer/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../utils.dart';
import '../base_view.dart';

class Home extends BaseView {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends BaseViewState {
  HomeBloc bloc = HomeBloc();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initInternetValidation();

    return Container(
      height: double.infinity,
      color: Colors.black87,
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              errorWidget(),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Image.asset(
                  'assets/icon.png',
                  alignment: Alignment.center,
                  height: 100.0,
                ),
              ),
              //storyTellingWidget(context),
              _searchView(),
              titleView('Top Week Selections'),
              topBeersOfWeek(),
              //buildCategorySearch(false),
              titleView('Categories'),
              buildCategorySearch(true),
              titleView(localizedText(context, LOCAL_BREWERS_TITLE)),
              _buildBrewersGrid(context),
              //_buildEventsCards(events),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _searchView() {
  return Container(
    margin: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    child: ListTile(
      leading: Icon(Icons.search),
      title: Text(
        'Buscar cerveza',
        style: TextStyle(color: Colors.grey[400]),
      ),
    ),
  );
}

Widget _buildBrewersGrid(context) {
  return StreamBuilder(
    stream: Firestore.instance.collection('brewers').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(
              snapshot.data.documents.length,
              (index) => _brewerCard(
                  context,
                  snapshot.data.documents[index].data['imageUri'],
                  snapshot.data.documents[index].data['name'],
                  index),
            ),
          ),
        );
      } else {
        return _shimmerBrewers();
      }
    },
  );
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
        6,
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

Widget _brewerCard(context, String url, String name, int index) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BrewersDetail(index)));
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

Column errorColumn(String brewerName) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        brewerName,
        style: TextStyle(color: Colors.white),
      ),
      Container(
        child: Icon(Icons.error),
      ),
    ],
  );
}
