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
        height: 200.0,
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Expanded(
          child: Stack(
            children: [
              Card(
                elevation: kCardElevation,
                color: Colors.white,
                child: ImageProviderWidget(
                  article.imageUri,
                  myBoxFit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 10.0,
                left: 15.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      color: kBlackLightColor),
                  child: Text(
                    article.title,
                    style: TextStyle(color: kWhiteColor, fontSize: 20.0),
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
                        style: TextStyle(
                            color: kWhiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
