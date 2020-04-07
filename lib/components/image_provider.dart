import 'package:craftbeer/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageProviderWidget extends StatelessWidget {
  final String imageUri;
  final Widget errorWidget;
  final double height;
  ImageProviderWidget(this.imageUri, {this.errorWidget, this.height});
  @override
  Widget build(BuildContext context) {
    if (imageUri == null || imageUri.isEmpty) {
      return SizedBox();
    } else {
      return CachedNetworkImage(
        fadeInDuration: Duration(milliseconds: 1500),
        imageUrl: imageUri,
        height: height,
        fit: BoxFit.scaleDown,
        placeholder: (context, url) => Image.network(url),
        errorWidget: (context, url, error) => SizedBox(
          height: 60.0,
        ),
      );
    }
  }
}
