import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/articlet_reader_page.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
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
        height: 300.0,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: article.title,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      child: ImageProviderWidget(
                        article.imageUri,
                        myBoxFit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isArticleNew(),
                    child: Positioned(
                      right: 20.0,
                      bottom: 10.0,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2.0)),
                            color: kGreenColor),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            S.of(context).new_label,
                            style: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment.center,
              child: Text(
                article.title,
                style: TextStyle(color: kWhiteColor, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
