import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/explore/categories_chips.dart';
import 'package:craftbeer/ui/explore/promotions.dart';
import 'package:craftbeer/ui/explore/search_widget.dart';
import 'package:craftbeer/ui/explore/top_beers.dart';
import 'package:craftbeer/ui/home/articles.dart';
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Expanded(
                  child: Card(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: titleView(S.of(context).home_learn_title,
                          color: kWhiteColor, margin: EdgeInsets.only(left: 15.0)),
                    ),
                    color: Colors.orangeAccent,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Card(
                        child: Container(
                          height: 95,
                          child: Column(
                            children: [
                              titleView(S.of(context).tasted_beers_title),
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/skullflowers.png',
                                  height: 60.0,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.blueAccent,
                      ),
                      Card(
                        child: Container(
                          height: 96,
                          child: Column(
                            children: [
                              titleView(S.of(context).local_brewers),
                              Container(
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/brewers.png',
                                  height: 60.0,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ],),
              SizedBox(
                height: kBigMargin,
              ),
              SearchWidget(),
              SizedBox(
                height: kBigMargin,
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 15.0),
                child: Image.asset(
                  'assets/compass.png',
                  height: 50.0,
                  alignment: Alignment.topLeft,
                ),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: 200,
                    height: 20,
                    color: kGreenColor,
                  )),
              titleView(S.of(context).categories, margin: EdgeInsets.only(left: 15.0)),
              SizedBox(
                height: kMarginTopFromTitle,
              ),
              CategoriesChips(
                scrollOnTap: scrollDown,
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
