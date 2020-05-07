import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromotionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Promotion> promotions = Provider.of<List<Promotion>>(context);

    if (promotions == null) {
      return LoadingWidget();
    }else if(promotions.isEmpty){
      return Image.asset('assets/emptyoffers.png',scale: 1.5);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        itemCount: promotions.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: cardDecoration(),
              elevation: kCardElevation,
              color: kBlackLightColor,
              semanticContainer: true,
              child: ImageProviderEventWidget(promotions[index].imageUri,
                  width: 160.0, height: 100.0));
        },
      ),
    );
  }
}