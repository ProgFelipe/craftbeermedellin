import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class EventMapMarketDetail extends StatelessWidget {
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
                Icon(BeerIcon.ticket_filled),
                Text(
                  'El mejor evento cervecero',
                  style: TextStyle(
                      fontSize: 15.0,
                      color: kMapDescriptionColor),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Este evento es patrocinado por los aguacates de Martinez',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15.0, color: Colors.grey,),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant, color: Colors.blue),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Nachos, Tacos, Fajas y Asados')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.queue_music, color: Colors.black38),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Banda en vivo')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.orangeAccent,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('100')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.accessible_forward, color: Colors.lightGreen),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Fácil acceso')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_parking,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Parking')
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.airport_shuttle),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text('Cerca a transporte público')
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'assets/event.gif',
                  width: 145.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
