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
            /* Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 100,
                itemBuilder: (context, index) => Container(
                  width: 100.0,
                  margin: EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: (){
                      showDialog(context: context,
                        builder: (context) => YoutubeVideoPlayer(),
                      );
                    },
                    child: CircleAvatar(
                      radius: 90.0,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.video_library),
                    ),
                  ),
                ),
              ),
            ),*/
            //YoutubeVideoPlayer(),
            Padding(
                padding: EdgeInsets.only(left: kMarginLeft),
                child:
                    titleView(S.of(context).events_title, color: kWhiteColor)),
            SizedBox(
              height: kMarginTopFromTitle,
            ),
            EventsWidget(),
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
      return Center(
        child: Container(
          child: Column(
            children: [
              Image.asset(
                'assets/empty_state_events.png',
                width: kEmptyStateWidth,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'No Events Found',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
    }
    return Expanded(
      flex: 2,
      child: Container(
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: events?.length ?? 0,
          itemBuilder: (BuildContext context, int index) =>
              EventCardWidget(event: events[index]),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }
}
