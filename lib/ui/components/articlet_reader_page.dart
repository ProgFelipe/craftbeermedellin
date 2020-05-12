import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class ArticleReader extends StatelessWidget {
  final Article article;

  ArticleReader({@required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                  tag: article.title,
                  child: ImageProviderWidget(
                    article.imageUri,
                    width: double.infinity,
                    myBoxFit: BoxFit.cover,
                  )),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: kBigMargin,),
                  titleView(article.title, color: kBlueColor, size: 20.0),
                  SizedBox(height: kMarginTopFromTitle,),
                  Text(
                    article.content,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
