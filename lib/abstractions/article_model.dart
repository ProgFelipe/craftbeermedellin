import 'package:flutter/cupertino.dart';

class Article {
  final String title;
  final String imageUri;
  final String content;

  Article(
      {@required this.title, @required this.imageUri, @required this.content});
}