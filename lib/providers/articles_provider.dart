import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/base_provider.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ArticlesData extends BaseProvider {
  final api = DataBaseService();

  List<Article> articles;

  ArticlesData() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    showLoading();
    try {
      var response = await api.fetchArticles();
      switch (response.statusCode) {
        case 200:
          {
            final jsonData = json.decode(utf8.decode(response.bodyBytes));
            articles = List();
            for (Map article in jsonData) {
              var articleObj = Article.fromJson(article);
              articles.add(articleObj);
              if(kDebugMode){
                print(article.length);
              }
            }
            hideLoading();
          }
          break;
        case 404:
          {
            print('404');
            hideLoading();
            break;
          }
        case 503:
          {
            print('503');
            hideLoading();
            break;
          }
        default:
          break;
      }
    }catch (exception, stacktrace) {
      print(stacktrace);
      hideLoading();
    }
  }
}
