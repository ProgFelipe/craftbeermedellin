import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/home/categories_view.dart';
import 'package:craftbeer/ui/home/promotions.dart';
import 'package:craftbeer/ui/home/search_widget.dart';
import 'package:craftbeer/ui/home/top_beers.dart';
import 'package:craftbeer/ui/home/articles.dart';
import 'package:craftbeer/ui/home/favorites_view.dart';
import 'package:craftbeer/ui/home/new_releases.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: Colors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              ConnectivityWidget(),
              News(),
              SizedBox(
                height: kMarginTopFromTitle,
              ),
              //Expanded(child: ArticlesWidget()),
              SizedBox(
                height: kBigMargin,
              ),
              SearchWidget(),
              SizedBox(
                height: kBigMargin,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticlesWidget()));
                      },
                      child: Card(
                        child: Container(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/kraken.png',
                                height: 100.0,
                                alignment: Alignment.topLeft,
                              ),
                              titleView(S.of(context).home_learn_title,
                                  color: kArticlesTextColor,
                                  margin: EdgeInsets.only(left: 15.0)),
                            ],
                          ),
                        ),
                        color: kArticlesYellow,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FavoritesView()));
                          },
                          child: Card(
                            child: Container(
                              height: 95,
                              child: Column(
                                children: [
                                  titleView(S.of(context).tasted_beers_title,
                                      color: kWhiteColor,
                                      size: 18.0,
                                      margin: EdgeInsets.only(top: 5.0, left: 5.0)),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.bottomRight,
                                      margin: EdgeInsets.only(right: 9.0),
                                      child: Image.asset(
                                        'assets/skullflowers.png',
                                        height: 60.0,
                                        alignment: Alignment.topLeft,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: kFavoritesBlack,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CategoriesView()));
                          },
                          child: Card(
                            child: Container(
                              height: 96,
                              child: Column(
                                children: [
                                  titleView(
                                    S.of(context).categories,
                                    size: 18.0,
                                    margin: EdgeInsets.only(top: 5.0, left: 5.0)
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: 60.0,
                                      margin: EdgeInsets.only(right: 15.0),
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                        'assets/compass.png',
                                        height: 50.0,
                                        alignment: Alignment.topLeft,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            color: kLightRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kBigMargin,
              ),
              titleView(S.of(context).promotions_title,
                  margin: EdgeInsets.only(left: 15.0)),
              SizedBox(
                height: kMarginTopFromTitle,
              ),
              PromotionsWidget(),
              SizedBox(
                height: kBigMargin,
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Image.asset(
                    'assets/pubbeer.png',
                    height: 50.0,
                    alignment: Alignment.topLeft,
                  )),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: 200,
                    height: 20,
                    color: kBlackLightColor,
                  )),
              titleView(S.of(context).top_week_title,
                  color: kWhiteColor, margin: EdgeInsets.only(left: 15.0)),
              SizedBox(
                height: kMarginTopFromTitle,
              ),
              TopBeersView(),
              SizedBox(
                height: kBigMargin,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
