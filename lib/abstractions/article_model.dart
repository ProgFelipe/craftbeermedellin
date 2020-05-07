import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Article {
  final String title;
  final String imageUri;
  final String content;
  final String articleType;
  final Timestamp timeStamp;

  Article(
      {@required this.timeStamp,
      @required this.title,
      @required this.articleType,
      @required this.imageUri,
      @required this.content});

  factory Article.fromJson(Map<String, dynamic> data) {
    return Article(
      title: data['name'] ?? '',
      imageUri: data['article_pic'] ?? '',
      content: data['content'] ?? '',
      articleType: data['article_type'] ?? '',
      timeStamp:
          Timestamp.fromDate(DateTime.parse(data['release_date'])) ?? null,
    );
  }
}
