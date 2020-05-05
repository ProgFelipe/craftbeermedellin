import 'package:craftbeer/ui/map/item_description.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class StoreMapMarketDetail extends StatelessWidget {
  final String storeName;
  final String storeDescription;
  final String foodDescription;
  final int capacity;
  final bool easyAccess;
  final int parkingLots;
  final bool publicTransport;

  StoreMapMarketDetail({@required this.storeName, this.storeDescription, this.foodDescription,
    this.capacity,
    this.easyAccess,
    this.parkingLots,
    this.publicTransport});

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
                Icon(Icons.store, color: kCitrusEndCustomColor,),
                SizedBox(width: 15.0,),
                Text(
                  storeName,
                  style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              storeDescription,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemDescription(icon: Icons.restaurant, description: foodDescription ?? '',),
                ItemDescription(icon: Icons.queue_music, description: 'Banda en vivo',),
                ItemDescription(icon: Icons.people, description: capacity?.toString() ?? '',),
                ItemDescription(icon: Icons.accessible_forward, description: 'Fácil acceso',),
                ItemDescription(icon: Icons.local_parking, description: parkingLots?.toString() ?? '',),
                ItemDescription(icon: Icons.airport_shuttle, description: 'Cerca a transporte público',),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
