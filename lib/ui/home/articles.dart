import 'dart:ui';

import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/articles_provider.dart';
import 'package:craftbeer/ui/home/article_card.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticlesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArticlesData>(
      builder: (context, articlesData, child) {
        if (articlesData.loadingState) {
          return LoadingWidget();
        }
        if (articlesData.articles == null || articlesData.articles.isEmpty) {
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
                      color: kGrayEmptyState,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        }
        return Container(
          alignment: Alignment.topLeft,
          child: ListView.builder(
            itemCount: articlesData.articles.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => ArticleCard(
              article: articlesData.articles[index],
            ),
          ),
        );
      },
    );
  }
}
