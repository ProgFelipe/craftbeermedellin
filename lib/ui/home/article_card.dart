import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/ui/components/articlet_reader_page.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({@required this.article});

  bool isArticleNew() {
    return article.timeStamp.toDate().difference(DateTime.now()).inDays < 5;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ArticleReader(
            article: article,
          );
        },
      )),
      child: Container(
        child: Stack(
          children: [
            Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Hero(
                tag: article.title,
                child: ImageProviderWidget(
                  article.imageUri,
                  myBoxFit: BoxFit.fill,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
            ),
            Positioned(
              child: Text(
                article.title,
                style: TextStyle(color: Colors.black54, fontSize: 20.0),
              ),
              left: 15.0,
              bottom: 20.0,
            ),
            Visibility(
              visible: isArticleNew(),
              child: Positioned(
                right: 15.0,
                bottom: 10.0,
                child: Chip(
                  label: Text(
                    'NEW',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  backgroundColor: kGreenColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
