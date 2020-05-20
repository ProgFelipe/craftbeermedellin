import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Article {
  final String title;
  final String imageUri;
  final String contentUri;
  final Timestamp timeStamp;

  Article(
      {@required this.timeStamp,
      @required this.title,
      @required this.imageUri,
      @required this.contentUri});

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
      title: data['name'] ?? '',
      imageUri: data['article_pic'] ?? '',
      contentUri: data['content_uri'] ?? '',
      timeStamp:
          Timestamp.fromDate(DateTime.parse(data['release_date'])) ?? null,
    );
  }
}
