import 'package:craftbeer/abstractions/store_model.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class StoreMapMarketDetail extends StatelessWidget {
  final Store store;

  StoreMapMarketDetail({@required this.store});

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
                Container(
                    height: 25.0, child: Image.asset('assets/marker_beer.png')),
                SizedBox(
                  width: 15.0,
                ),
                Text(
                  store.name,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Visibility(
                    visible: store.publicTransport,
                    child: Icon(Icons.directions_bus, color: kGreenColor)),
                Visibility(
                    visible: store.parking,
                    child: Icon(
                      Icons.local_parking,
                      color: kGreenColor,
                    )),
                Visibility(
                    visible: store.easyAccess,
                    child: Icon(Icons.accessible_forward, color: kGreenColor)),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              store.openHours,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                color: kMapDescriptionColor,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ImageProviderWidget(store.imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}
