import 'dart:io';

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/beer_detail_dialog.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/components/ios_back_nav.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class BrewerHeader extends StatefulWidget {
  final Brewer brewer;
  final Function onFavSelected;
  final Function oniOSBackPressed;
  BrewerHeader({@required this.brewer, @required this.onFavSelected, @required this.oniOSBackPressed});
  
  @override
  _BrewerHeaderState createState() => _BrewerHeaderState();
}

class _BrewerHeaderState extends State<BrewerHeader> {

  showBrewerMoreInfo(Brewer brewer, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => BeerDetailDialog(
        title: brewer.name,
        description: brewer.aboutUs,
        buttonText: S.of(context).back,
        avatarImage: brewer.imageUri,
        avatarColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ConnectivityWidget(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IosBackNav(
                  onBack: widget.oniOSBackPressed),
              Expanded(
                child: Text(
                  widget.brewer.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Visibility(
                visible: Platform.isIOS,
                child: SizedBox(
                  width: 40.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Hero(
              tag: widget.brewer.name,
              child: ImageProviderWidget(
                widget.brewer.imageUri,
                height: 100.0,
                animationDuration: 0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              widget.brewer.description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.normal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: widget.brewer.aboutUs.isNotEmpty,
                child: FlatButton.icon(
                  color: Colors.black54,
                  onPressed: () => showBrewerMoreInfo(
                      widget.brewer, context),
                  icon: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  label: RichText(
                    text: TextSpan(
                      text: S.of(context).know_us,
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.0,),
              GestureDetector(
                onTap:  widget.onFavSelected,
                child: CircleAvatar(
                  backgroundColor: kCitrusEndCustomColor,
                  radius: 20.0,
                  child: Icon(
                    widget.brewer.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 20.0,
                    color: kWhiteColor,
                  ),
                ),
              ),
              SizedBox(width: 10.0,),
              GestureDetector(
                onTap: (){},
                child: CircleAvatar(
                  backgroundColor: kCitrusEndCustomColor,
                  radius: 20.0,
                  child: Center(
                    child:  Icon(
                      Icons.share,
                      size: 20.0,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
