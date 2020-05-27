import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/explore/categories_chips.dart';
import 'package:craftbeer/ui/explore/promotions.dart';
import 'package:craftbeer/ui/explore/search_widget.dart';
import 'package:craftbeer/ui/explore/top_beers.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  @override
  _ExploreViewState createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> with AutomaticKeepAliveClientMixin<ExploreView> {

  ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void putScrollAtTop() {
    /*_scrollController.animateTo(
      240.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );*/
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ConnectivityWidget(),
            SizedBox(
              height: kBigMargin,
            ),
            SearchWidget(putScrollAtTop),
            SizedBox(
              height: kBigMargin,
            ),
            titleView(
              S.of(context).promotions_title,
            ),
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
                  height: 100.0,
                  alignment: Alignment.topLeft,
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
              child: Image.asset(
                'assets/compass.png',
                height: 100.0,
                alignment: Alignment.topLeft,
              ),
            ),
            Container( alignment: Alignment.topLeft,child: Container(width: 200, height: 20, color: kGreenColor,)),
            titleView(S.of(context).categories),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            CategoriesChips(scrollOnTap: scrollDown,),
          ],
        ),
      ),),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
