import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/events/event_card_widget.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class EventsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [Colors.black, Colors.blueGrey],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ConnectivityWidget(),
              titleView(localizedText(context, PROMOTIONS_TITLE)),
              PromotionsWidget(),
              titleView(localizedText(context, EVENTS_TITLE)),
              EventsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Promotion> promotions = Provider.of<List<Promotion>>(context);

    if (promotions == null || promotions.isEmpty) {
      return Text('No promotions');
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

class EventsWidget extends StatelessWidget {
  final db = DataBaseService();
  @override
  Widget build(BuildContext context) {
    List<Event> events = Provider.of<List<Event>>(context);
    if (events == null || events.isEmpty) {
      return LoadingWidget();
    }
    return Container(
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: events?.length ?? 0,
        itemBuilder: (BuildContext context, int index) =>
            EventCardWidget(event: events[index]),
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
