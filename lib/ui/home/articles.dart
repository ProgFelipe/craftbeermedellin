import 'dart:math';
import 'dart:ui';

import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/articles_provider.dart';
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
      builder: (context, articlesData, child) {
        if (articlesData.loadingState) {
          return LoadingWidget();
        }
        return PrimaryArticles(articles: articlesData.articles);
      },
    );
  }
}

class PrimaryArticles extends StatelessWidget {
  final List<Article> articles;

  const PrimaryArticles({this.articles});

  @override
  Widget build(BuildContext context) {
    if (articles == null || articles.isEmpty) {
      return Container(
        child: Column(
          children: [
            Image.asset('assets/empty_state_articles.png',
                width: kEmptyStateWidth),
            SizedBox(
              height: 20.0,
            ),
            Text(
              S.of(context).empty_state_articles,
              style: TextStyle(
                  color: emptyStateTextColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
    return Container(
      alignment: Alignment.topLeft,
      height: 200.0,
      child: ListView.builder(
        itemCount: articles.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) =>
            ArticleCard(
              article: articles[index],
            ),
      ),
    );
  }
}
