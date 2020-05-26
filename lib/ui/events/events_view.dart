import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/events/event_card_widget.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class EventsView extends StatefulWidget {
  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView>
    with AutomaticKeepAliveClientMixin<EventsView> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: double.infinity,
      color: kBlackColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            ConnectivityWidget(),
            SizedBox(
              height: kBigMargin,
            ),
            Padding(
                padding: EdgeInsets.only(left: kMarginLeft),
                child:
                    titleView(S.of(context).events_title, color: kWhiteColor)),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            Expanded(child: EventsWidget()),
            SizedBox(
              height: kBigMargin,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class EventsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Event> events = Provider.of<List<Event>>(context);
    if (events == null) {
      return LoadingWidget();
    }
    if (events.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/empty_state_events.png',
              width: kEmptyStateWidth,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              S.of(context).empty_state_events,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
    return Container(
      child: StaggeredGridView.countBuilder(
        key: UniqueKey(),
        crossAxisCount: 4,
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
