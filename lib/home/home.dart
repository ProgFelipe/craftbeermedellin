import 'package:craftbeer/brewers_detail.dart';
import 'package:craftbeer/components/story_telling.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus == 'ConnectivityResult.none') {
      return Center(child: Text('Connection Status: $connectionStatus\n'));
      //return _content(events, internet: false);
    } else {
      return Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [Colors.black, Colors.blueGrey],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Image.asset(
                    'assets/icon.png',
                    alignment: Alignment.center,
                    height: 100.0,
                  ),
                ),
                storyTellingWidget(),
                SizedBox(
                  height: 10.0,
                ),
                TitleTextUtils('Cervecerias Locales', Colors.white, 50.0),
                _buildBrewersGrid(context),
                //_buildEventsCards(events),
              ],
              /*StreamBuilder(
                  stream: Firestore.instance.collection('brewers').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return _shimmerLoading();
                    } else {
                      return _shimmerLoading();
                    }
                  },
                ),*/
            ),
          ),
        ),
      );
    }
  }
}

Widget _buildBrewersGrid(context) {
  //https://stackoverflow.com/questions/48405123/how-to-set-custom-height-for-widget-in-gridview-in-flutter
  //var size = MediaQuery.of(context).size;
  //var statusBarHeight = 24;
  //final double itemHeight = (size.height - kToolbarHeight - statusBarHeight) / 2;
  //final double itemWidth = size.width / 2;
  return StreamBuilder(
    stream: Firestore.instance.collection('brewers').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        debugPrint('Cargó ${snapshot.data.documents}');
        return Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            children: List.generate(
              snapshot.data.documents.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: _buildCustomCard(context,
                    snapshot.data.documents[index].data['imageUri'], index),
              ),
            ),
          ),
        );
      } else {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(
                6,
                (index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: _shimmerCard(),
                ),
              ),
            ),
          ),
        );
      }
    },
  );
}

Widget _shimmerCard() {
  return Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: Card(
      elevation: 4.0,
      child: Container(
        width: 150.0,
        height: 60.0,
        color: Colors.white,
      ),
    ),
  );
}

Widget _buildCustomCard(context, String url, int index) {
  debugPrint('URL: $url');
  return GestureDetector(
    onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BrewersDetail(index)));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(90.0),
        ),
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [Colors.black, Colors.white.withOpacity(0.4)],
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 1500),
              imageUrl: url,
              fit: BoxFit.scaleDown,
              placeholder: (context, url) => Image.network(url),
              errorWidget: (context, url, error) => Card(
                elevation: 4.0,
                child: Container(
                  child: Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
