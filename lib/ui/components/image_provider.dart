import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageProviderWidget extends StatelessWidget {
  final String imageUri;
  final Widget errorWidget;
  final double height;
  final double width;
  final int animationDuration;
  ImageProviderWidget(this.imageUri,
      {this.errorWidget, this.height, this.width, this.animationDuration});
  @override
  Widget build(BuildContext context) {
    if (imageUri == null || imageUri.isEmpty) {
      return Image.asset(
        'assets/beer.png',
        height: height,
        width: width,
        fit: BoxFit.scaleDown,
      );
    } else {
      return Center(
        child: CachedNetworkImage(
          fadeInDuration: Duration(milliseconds: 500),
          imageUrl: imageUri,
          height: height,
          width: width,
          fit: BoxFit.cover,
          placeholder: (context, url) => Image.network(url),
          errorWidget: (context, url, error){if(url.contains('assets')){
            return Container(
              height: 120.0,
              width: 60.0,
              child: Image.asset(url),
            );
          }else{
            return Image.asset(
              'assets/beer.png',
              height: height,
              width: width,
              fit: BoxFit.scaleDown,
            );}},
        ),
      );
    }
  }
}
