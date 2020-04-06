import 'dart:async';

import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventCardWidget extends StatefulWidget {
  final Event event;
  EventCardWidget({this.event});
  @override
  _EventCardWidgetState createState() => _EventCardWidgetState(event: event);
}

class _EventCardWidgetState extends State<EventCardWidget> {
  final Event event;
  _EventCardWidgetState({this.event});

  Timer _timer;
  int _start = 10;
  DateTime eventLeftTime;

  void startTimer() {
    debugPrint('START TIMER');
    if (event.dateTime != null) {
      eventLeftTime = event.dateTime;
      const oneSec = const Duration(seconds: 2);
      const oneMinute = const Duration(minutes: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
            } else {
              eventLeftTime = eventLeftTime.subtract(oneMinute);
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardDecoration(),
      elevation: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(DecorationConsts.cardRadius),
                  topRight: Radius.circular(DecorationConsts.cardRadius)),
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 1500),
                imageUrl: event.imageUri,
                fit: BoxFit.scaleDown,
                placeholder: (context, url) => Image.network(url),
                errorWidget: (context, url, error) => Card(
                  elevation: 4.0,
                  child: Container(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.date_range, color: Colors.grey),
                Text(
                  event.date,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          cardTitle(event.name),
          cardTitle(event.city),
          Center(child: _buildTimerButton()),
          SizedBox(
            height: 10.0,
          )
          //cardTitle(event['description']),
        ],
      ),
    );
  }

  Widget _buildTimerButton() {
    return Container(
        alignment: Alignment.center,
        width: 130.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
            borderRadius: new BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Colors.blue,
            ),
            Text(
              //'8 hours 20 min',
              "$_start ${eventLeftTime?.hour ?? ''}: ${eventLeftTime?.minute ?? ''}: ${eventLeftTime?.second ?? ''}",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
