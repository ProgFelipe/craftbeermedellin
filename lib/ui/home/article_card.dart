import 'package:craftbeer/abstractions/article_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/articlet_reader_page.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

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
      child: Stack(
        children: [
          Card(
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kCardRadius),
            ),
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kCardRadius),
              child: ImageProviderWidget(
                article.imageUri,
                myBoxFit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 5.0,
            right: 5.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    color: kBlackLightColor),
                child: Text(
                  article.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 15.0,),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isArticleNew(),
            child: Positioned(
              right: 10.0,
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
                        color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
