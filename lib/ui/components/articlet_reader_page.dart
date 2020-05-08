import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class ArticleReader extends StatelessWidget {
  final Article article;

  ArticleReader({@required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          Hero(tag: article.title, child: ImageProviderWidget(article.imageUri)),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    titleView(article.title, color: kBlueColor),
                    Text(
                      article.content,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
