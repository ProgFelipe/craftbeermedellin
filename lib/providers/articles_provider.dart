import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ArticlesData extends BaseProvider {
  final api = Api();

  List<Article> articles;

  static final ArticlesData _singleton = ArticlesData._internal();

  factory ArticlesData() {
    return _singleton;
  }

  ArticlesData._internal(){
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    showLoading();
    try {
      var response = await api.fetchArticles();
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        articles = List();
        for (Map article in jsonData) {
          var articleObj = Article.fromJson(article);
          articles.add(articleObj);
          if (kDebugMode) {
            print(article.length);
          }
        }
      }
      hideLoading();
    } catch (exception, stacktrace) {
      debugPrint("$stacktrace");
      hideLoading();
    }
  }
}
