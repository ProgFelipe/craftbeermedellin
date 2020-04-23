import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/database_service.dart';
import 'package:craftbeer/events/event_card_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class EventsView extends StatefulWidget {
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> with AutomaticKeepAliveClientMixin<EventsView> {
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
              titleView(S.of(context).promotions_title),
              PromotionsWidget(),
              titleView(S.of(context).events_title),
              EventsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PromotionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Promotion> promotions = Provider.of<List<Promotion>>(context);

    if (promotions == null) {
      return LoadingWidget();
    }else if(promotions.isEmpty){
      return Image.asset('assets/emptyoffers.png',scale: 1.5);
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
    if (events == null) {
      return LoadingWidget();
    }else if(events.isEmpty){
      return Image.asset('assets/emptyevent.png', scale: 1.5,);
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
