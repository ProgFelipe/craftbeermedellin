import 'dart:async';
import 'dart:core';

import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/components/image_provider.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      "${S.of(context).days}: ${twoDigits(duration.inDays)}\n ${S.of(context).hours}:${twoDigits(duration.inHours)}";

  bool isSameDate(DateTime one, DateTime other) {
    return one.year == other.year &&
        one.month == other.month &&
        one.day == other.day;
  }

  void startTimer() {
    if (event.timestamp != null &&
        //Not pass events or same day
        (!event.timestamp.toDate().isBefore(DateTime.now()) ||
            isSameDate(event.timestamp.toDate(), DateTime.now()))) {
      eventLeftTime = event.timestamp.toDate().difference(DateTime.now());
      if (eventLeftTime.inHours >= 0 && eventLeftTime.inHours <= 24) {
        todayEventTimer();
      } else if (eventLeftTime.inDays > 0) {
        setState(() {
          showRemainEventDaysLabel = true;
        });
      }
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
    startTimer();
    debugPrint('INIT STATE EVENTCARD');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('DISPOSE STATE EVENTCARD');
    _timer?.cancel();
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
                    child: ImageProviderWidget(event.imageUri)),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: Visibility(
                  visible: event?.timestamp != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.date_range, color: Colors.grey),
                      Text(
                        event.timestamp != null
                            ? _dateFormat.format(event.timestamp.toDate())
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
              "${eventLeftTime?.inDays ?? ''} ${S.of(context).days}",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
