import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class EventMapMarketDetail extends StatelessWidget {
  final Event event;

  EventMapMarketDetail({
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.0,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(
                  BeerIcon.ticket_filled,
                  color: Colors.redAccent,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  event.description,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ImageProviderWidget(event.imageUri),
            )
          ],
        ),
      ),
    );
  }
}
