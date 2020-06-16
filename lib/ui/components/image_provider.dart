import 'dart:io';

import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

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
    return Consumer<BrewersData>(builder: (context, brewerData, child) {
      return Center(
        child: CachedNetworkImage(
          cacheManager: brewerData.baseCacheManager,
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
            try {
              if (error is SocketException) {
              } else if (error?.statusCode == 403) {
                brewerData.clearCache();
              }
            } catch (e) {}
            return Container(
                height: 100,
                color: Colors.white,
                child: Icon(
                  Icons.error,
                  size: 40.0,
                ));
          },
        ),
      );
    });
  }
}
