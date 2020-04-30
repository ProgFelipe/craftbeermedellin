import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
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
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        itemCount: promotions.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: cardDecoration(),
              elevation: 3.0,
              color: Colors.white,
              semanticContainer: true,
              child: Image.network(promotions[index].imageUri,
                  width: 160.0, height: 100.0, fit: BoxFit.cover));
        },
      ),
    );
  }
}