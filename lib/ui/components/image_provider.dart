import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        fadeInDuration: Duration(milliseconds: 500),
        imageUrl: imageUri,
        height: height,
        width: width,
        fit: myBoxFit ?? BoxFit.cover,
        useOldImageOnUrlChange: true,
        progressIndicatorBuilder: (context, url, progress) => Container(
            height: 100.0,
            width: 100.0,
            child: Container(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            )),
        errorWidget: (context, url, error) {
          return Container(
              height: 100,
              child: Icon(
                Icons.error,
                size: 40.0,
              ));
        },
      ),
    );
  }
}
