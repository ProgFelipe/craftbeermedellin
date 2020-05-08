import 'dart:math';
import 'dart:ui';

import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/models/articles_data_notifier.dart';
import 'package:craftbeer/ui/home/article_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
                Container(height:150.0, alignment: Alignment.topLeft, child: MoreArticles(articles: articlesData.secondaryArticles, randomColor: RandomColor(),)),
                PrimaryArticles(articles: articlesData.articles)
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
    return articles!= null &&
        articles.isNotEmpty
        ? StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 1,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) {
                return ArticleReader( articles[index]);
              },
            ));
          },
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                      Radius.elliptical(0, 0)
                  )
              ),
              elevation: 3.0,
              color: randomColor.getRandomColor(),
              semanticContainer: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  articles[index].title,
                  style: TextStyle(color: Colors.white),
                ),
              )),
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
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
        ? ListView.builder(
            itemCount: articles.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            itemBuilder: (context, index) =>
                ArticleCard(article: articles[index]),
          )
        : Text(
            'Could not get articles',
            style: TextStyle(color: kWhiteColor),
          );
  }
}

class ArticleReader extends StatefulWidget {
  final Article article;

  ArticleReader(this.article);

  @override
  _ArticleReaderState createState() => _ArticleReaderState();
}

class _ArticleReaderState extends State<ArticleReader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              children: [
                titleView(widget.article.title, color: kBlueColor),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  widget.article.content,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
