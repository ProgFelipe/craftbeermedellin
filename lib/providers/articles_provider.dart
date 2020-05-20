import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class ArticlesData extends ChangeNotifier {
  final api = DataBaseService();

  List<Article> articles;

  ArticlesData() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    var response = await api.fetchArticles();
    switch (response.statusCode) {
      case 200:
        {
          final jsonData = json.decode(utf8.decode(response.bodyBytes));
          articles = List();
          for (Map article in jsonData) {
            var articleObj = Article.fromJson(article);
            articles.add(articleObj);
          }
          notifyListeners();
        }
        break;
      case 404:
        {
          print('404');
          break;
        }
      case 503:
        {
          print('503');
          break;
        }
      default:
        break;
    }
  }
}
