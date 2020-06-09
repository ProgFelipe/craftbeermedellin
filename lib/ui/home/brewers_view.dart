import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/home/brewers_grid.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class BrewersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kBigMargin,
            ),
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/brewers.png',
                height: 80.0,
                alignment: Alignment.topLeft,
              ),
            ),
            Container(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 200,
                  height: 20,
                  color: Colors.redAccent,
                )),
            titleView(S.of(context).local_brewers,
                margin: EdgeInsets.only(left: 15.0)),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            BrewersGrid(),
            SizedBox(
              height: kBigMargin,
            ),
          ],
        ),
      ),
    );
  }
}
