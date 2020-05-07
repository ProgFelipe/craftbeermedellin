import 'dart:math';

import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/models/articles_data_notifier.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
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
    kRedColor,
    kBlueColor,
    kBlackLightColor,
    kZiSePurpleColor,
    kYellowColor,
    kGreenColor
  ];

  final random = Random();

  Color getRandomColor() {
    return colors[random.nextInt(colors.length - 1)];
  }
}

class _ArticlesWidgetState extends State<ArticlesWidget> {
  final RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      alignment: Alignment.topLeft,
      child: Consumer<ArticlesData>(
        builder: (context, articlesData, child) =>
            articlesData.secondaryArticles != null &&
                    articlesData.secondaryArticles.isNotEmpty
                ? StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: articlesData.secondaryArticles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return ArticleReader( articlesData.secondaryArticles[index]);
                            },
                          ));
                        },
                        child: Card(
                            shape: cardDecoration(),
                            elevation: 3.0,
                            color: _randomColor.getRandomColor(),
                            semanticContainer: true,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                articlesData.secondaryArticles[index].title,
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
                  ),
      ),
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
                  style: TextStyle(fontSize: 15.0,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
