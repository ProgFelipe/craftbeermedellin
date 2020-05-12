import 'dart:math';
import 'dart:ui';

import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/models/articles_data_notifier.dart';
import 'package:craftbeer/ui/components/articlet_reader_page.dart';
import 'package:craftbeer/ui/home/article_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticlesWidget extends StatefulWidget {
  @override
  _ArticlesWidgetState createState() => _ArticlesWidgetState();
}

class RandomColor {
  final colors = [
    kCitrusEndCustomColor,
    kBlueColor,
    kBlackLightColor,
    kZiSePurpleColor,
    kGreenColor
  ];

  final random = Random();

  Color getRandomColor() {
    return colors[random.nextInt(colors.length - 1)];
  }
}

class _ArticlesWidgetState extends State<ArticlesWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesData>(
        builder: (context, articlesData, child) => Column(
              children: [
                MoreArticles(
                  articles: articlesData.secondaryArticles,
                  randomColor: RandomColor(),
                ),
                SizedBox(
                  height: kBigMargin,
                ),
                PrimaryArticles(
                    articles: articlesData.articles)
              ],
            ));
  }
}

class MoreArticles extends StatelessWidget {
  final RandomColor randomColor;

  final List<Article> articles;

  const MoreArticles({this.articles, this.randomColor});

  @override
  Widget build(BuildContext context) {
    return articles != null && articles.isNotEmpty
        ? Container(
            height: 80.0,
            alignment: Alignment.topLeft,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return ArticleReader(
                              article: articles[index],
                            );
                          },
                        ));
                      },
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.elliptical(0, 0))),
                          elevation: kCardElevation,
                          color: randomColor.getRandomColor(),
                          semanticContainer: true,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                articles[index].title,
                                maxLines: 3,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    )),
          )
        : Text(
            'Text not articles found',
            style: TextStyle(color: kWhiteColor),
          );
  }
}

class PrimaryArticles extends StatelessWidget {
  final List<Article> articles;

  const PrimaryArticles({this.articles});

  @override
  Widget build(BuildContext context) {
    return articles != null && articles.isNotEmpty
        ? Container(
            alignment: Alignment.topLeft,
            height: 160.0,
            child: ListView.builder(
              itemCount: articles.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) => ArticleCard(
                article: articles[index],
              ),
            ),
          )
        : Text(
            'Could not get articles',
            style: TextStyle(color: kWhiteColor),
          );
  }
}
