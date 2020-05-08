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
          print('*****ERRROROROROROROROROR');
          print(url);
          print(error);
          return Icon(Icons.error);
        },
      ),
    );
  }
}

class ImageProviderEventWidget extends StatelessWidget {
  final String imageUri;
  final double height;
  final double width;
  final int animationDuration;

  ImageProviderEventWidget(
    this.imageUri, {
    this.height,
    this.width,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInDuration: Duration(milliseconds: 250),
      imageUrl: '',
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset(
        'assets/emptyoffers.png',
        height: height,
        width: width,
        fit: BoxFit.scaleDown,
      ),
      errorWidget: (context, url, error) {
        if (url.contains('assets')) {
          return Container(
            height: height ?? 120.0,
            width: 60.0,
            child: Image.asset(url),
          );
        } else {
          return Image.asset(
            'assets/emptyoffers.png',
            height: height,
            width: width,
            fit: BoxFit.scaleDown,
          );
        }
      },
    );
  }
}
