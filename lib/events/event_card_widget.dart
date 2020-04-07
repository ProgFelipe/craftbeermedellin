import 'dart:async';
import 'dart:core';
import 'package:craftbeer/components/image_provider.dart';
import 'package:intl/intl.dart';
import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';

class EventCardWidget extends StatefulWidget {
  final Event event;
  EventCardWidget({this.event});
  @override
  _EventCardWidgetState createState() => _EventCardWidgetState(event: event);
}

class _EventCardWidgetState extends State<EventCardWidget> {
  final Event event;
  final DateFormat _dateFormat = new DateFormat(" dd \'de\' MMMM");

  _EventCardWidgetState({this.event});
  Timer _timer;
  Duration eventLeftTime;

  String remainEventCountDown;
  bool showTodayCounter = false;
  bool showRemainEventDaysLabel = false;

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String getFormattedDurationString(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String getFormattedDayHoursDurationString(Duration duration) =>
      "días: ${twoDigits(duration.inDays)}\n horas:${twoDigits(duration.inHours)}";

  bool isSameDate(DateTime one, DateTime other) {
    return one.year == other.year &&
        one.month == other.month &&
        one.day == other.day;
  }

  void startTimer() {
    if (event.dateTime != null &&
        (!event.dateTime.isBefore(DateTime.now()) ||
            isSameDate(event.dateTime, DateTime.now()))) {
      eventLeftTime = event.dateTime.difference(DateTime.now());
      if (eventLeftTime.inHours <= 24) {
        todayEventTimer();
      } else {
        setState(() {
          showRemainEventDaysLabel = true;
        });
      }
    } else {
      debugPrint('EVENT IN PASS ${event.name}');
    }
  }

  void todayEventTimer() {
    const oneSecond = Duration(seconds: 1);
    setState(() {
      showTodayCounter = true;
      showRemainEventDaysLabel = true;
    });
    _timer = new Timer.periodic(
      oneSecond,
      (Timer timer) => setState(
        () {
          if (eventLeftTime.inSeconds <= 0) {
            timer.cancel();
          } else {
            eventLeftTime = eventLeftTime - oneSecond;
            remainEventCountDown = getFormattedDurationString(eventLeftTime);
          }
        },
      ),
    );
  }

  @override
  void initState() {
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
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(DecorationConsts.cardRadius),
                        topRight: Radius.circular(DecorationConsts.cardRadius)),
                    child: ImageProviderWidget(event.imageUri)
                    /*CachedNetworkImage(
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
                  ),*/
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: Visibility(
                  visible: event?.dateTime != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.date_range, color: Colors.grey),
                      Text(
                        event.dateTime != null
                            ? _dateFormat.format(event.dateTime)
                            : '',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              cardTitle(event.name),
              cardTitle(event.city),
              Visibility(
                  visible: showRemainEventDaysLabel,
                  child: Center(child: _buildTimerButton())),
              SizedBox(
                height: 10.0,
              )
              //cardTitle(event['description']),
            ],
          ),
          Visibility(
            visible: showTodayCounter,
            child: Positioned(
              child: Text(
                remainEventCountDown ?? '',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              top: 10.0,
              right: 10.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimerButton() {
    return Container(
        alignment: Alignment.center,
        width: 130.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
              "${eventLeftTime?.inDays ?? ''} días ${eventLeftTime?.inHours ?? ''} hrs",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
