import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
import 'package:flutter/material.dart';

class Offers extends StatelessWidget {
  final List<Promotion> promos;
  Offers({@required this.promos});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: promos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: cardDecoration(),
              elevation: 3.0,
              color: Colors.white,
              semanticContainer: true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.network(promos[index].imageUri,
                        width: 100.0, fit: BoxFit.cover),
                    Text(promos[index].description),
                    //Text(left[index]),
                  ],
                ),
              ));
        },
      ),
    );
  }
}