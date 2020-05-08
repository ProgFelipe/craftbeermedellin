import 'dart:async';
import 'dart:core';

import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
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
      child: Column(
        children: [
          Card(
            shape: cardDecoration(),
            elevation: kCardElevation,
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(DecorationConsts.cardRadius),
                      ),
                      child: ImageProviderWidget(
                        event.imageUri,
                        myBoxFit: BoxFit.fill,
                      )),
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
                ),
                Column(
                  children: [],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: Column(children: [
                Visibility(
                  visible: event?.timestamp != null,
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      event.timestamp != null
                          ? _dateFormat.format(event.timestamp.toDate())
                          : '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kBlackColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Text(
                    event.city ?? '',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: kBlackColor),
                    textAlign: TextAlign.left,
                  ),
                ),
                Visibility(
                  visible: showRemainEventDaysLabel,
                  child: Container(
                    width: double.infinity,
                    child: eventLeftTime?.inDays > 0 ? Text(
                      //'8 hours 20 min',
                      "${eventLeftTime?.inDays ?? ''} ${S.of(context).days} left",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.left,
                    ) : Text(
                      //'8 hours 20 min',
                      "Is Today!!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: kZelyonyGreenLightColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                )

              ],)),

        ],
      ),
    );
  }
}
