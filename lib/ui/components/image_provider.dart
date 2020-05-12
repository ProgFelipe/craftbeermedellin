import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageProviderWidget extends StatelessWidget {
  final String imageUri;
  final double height;
  final double width;
  final int animationDuration;
  final BoxFit myBoxFit;

  ImageProviderWidget(this.imageUri,
      {this.height, this.width, this.animationDuration, this.myBoxFit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        fadeInDuration: Duration(milliseconds: 250),
        imageUrl: imageUri,
        height: height,
        width: width,
        fit: myBoxFit ?? BoxFit.cover,
        useOldImageOnUrlChange: true,
        placeholder: (context, url) => Image.asset(
          'assets/icon.png',
          height: height,
          width: width,
          fit: BoxFit.scaleDown,
        ),
        errorWidget: (context, url, error) {
          return Icon(FontAwesomeIcons.exclamationCircle);
        },
      ),
    );
  }
}