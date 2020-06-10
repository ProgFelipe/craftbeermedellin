import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/home/categories_chips.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: kBlackColor,
     body: SafeArea(
       child: Column(children: [
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
         titleView(S.of(context).categories,
             margin: EdgeInsets.only(left: 15.0)),
         SizedBox(
           height: kMarginTopFromTitle,
         ),
         CategoriesChips(
           scrollOnTap: (){},
         ),
       ],),
     ),
    );
  }
}
