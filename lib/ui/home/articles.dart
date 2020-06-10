import 'dart:ui';

import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/articles_provider.dart';
import 'package:craftbeer/ui/home/article_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ArticlesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Consumer<ArticlesData>(
          builder: (context, articlesData, child) {
            if (articlesData.loadingState) {
              return Center(child: LoadingWidget());
            }
            if (articlesData.articles == null || articlesData.articles.isEmpty) {
              return Expanded(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/empty_state_articles.png',
                          width: kEmptyStateWidth),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        S
                            .of(context)
                            .empty_state_articles,
                        style: TextStyle(
                            color: kGrayEmptyState,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(height: kMarginTopFromTitle,),
                Image.asset(
                  'assets/kraken.png',
                  height: 100.0,
                  alignment: Alignment.topLeft,
                ),
                titleView(S.of(context).home_learn_title,
                    color: kWhiteColor,
                    margin: EdgeInsets.only(left: 15.0)),
                Expanded(
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: articlesData.articles.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ArticleCard(
                          article: articlesData.articles[index],
                        ),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
