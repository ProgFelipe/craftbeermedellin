import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
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
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotions.length,
        itemBuilder: (BuildContext context, int index) {
          return ImageProviderEventWidget(promotions[index].imageUri,
              width: 150.0, height: 200.0);
        },
      ),
    );
  }
}