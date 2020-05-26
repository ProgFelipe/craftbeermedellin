import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: Colors.black,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ConnectivityWidget(),
            News(),
            SizedBox(
              height: kBigMargin,
            ),
            /*Container(
                width: double.infinity,
                child: Image.asset(
                  'assets/kraken.png',
                  height: 150.0,
                  alignment: Alignment.topLeft,
                )),*/
            titleView(S.of(context).home_learn_title,
                color: kWhiteColor, margin: EdgeInsets.only(left: 15.0)),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            Expanded(child: ArticlesWidget()),
            SizedBox(
              height: kBigMargin,
            ),
            /*titleView('Feeds', color: Colors.white),
            LastComments(),*/
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
