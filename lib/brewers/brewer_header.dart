import 'dart:io';

import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';

class BrewerHeader extends StatefulWidget {
  final Brewer brewer;
  BrewerHeader(this.brewer);
  @override
  _BrewerHeaderState createState() => _BrewerHeaderState(brewer);
}

class _BrewerHeaderState extends State<BrewerHeader> {
  final Brewer brewer;
  _BrewerHeaderState(this.brewer);
  Widget backIfIos() {
    if (Platform.isIOS) {
      return FlatButton.icon(
        onPressed: () {
          updateFavoriteIfChanged();
        },
        icon: Icon(
          Icons.home,
          size: 40.0,
          color: Colors.white,
        ),
        label: Text(''),
      );
    } else {
      return SizedBox();
    }
  }

  bool favorite;

  @override
  void initState() {
    favorite = brewer.stateIsFavorite;
    super.initState();
  }

  updateFavoriteIfChanged() {
    brewer.stateIsFavorite = favorite;
    Navigator.pop(context);
  }

  showBrewerMoreInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) => BeerDetailDialog(
        title: brewer.name,
        description: brewer.aboutUs,
        buttonText: S.of(context).back,
        avatarImage: brewer.brewersImageUri,
        avatarColor: Colors.white,
      ),
    );
  }

  double get headerHeight => (MediaQuery.of(context).size.height * 0.5);

  //WillPopScope(
  //        //onWillPop: () => updateFavoriteIfChanged(),
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ConnectivityWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                backIfIos(),
                Text(
                  brewer.name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
                Icon(Icons.notifications, color: Colors.white,),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Hero(
              tag: 'logo',
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: ImageProviderWidget(brewer.imageUri,
                    height: 100.0),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              brewer.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
              maxLines: 5,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  color: Colors.black54,
                  onPressed: showBrewerMoreInfo,
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  label: RichText(
                    text: TextSpan(
                      text: S.of(context).know_us,
                      style: new TextStyle(
                          color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
                FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      favorite = !favorite;
                    });
                  },
                  icon: Icon(
                    favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 40.0,
                    color: Colors.red,
                  ),
                  label: Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
