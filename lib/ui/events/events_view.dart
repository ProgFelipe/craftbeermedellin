import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/components/generic_empty_state.dart';
import 'package:craftbeer/ui/events/event_card_widget.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/ui/utils/dimen_constants.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
              height: 10.0,
            ),
            Container(
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
            ),
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
    } else if (events.isEmpty) {
      return GenericEmptyState();
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

///https://pub.dev/packages/youtube_player_flutter#-example-tab-
class YoutubeVideoPlayer extends StatefulWidget {
  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 50;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'KpqRKLigVTw',
    'qiYKD1FZ5YM',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _controller.metadata.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: () {
            //_showSnackBar('Settings Tapped!');
          },
        ),
      ],
      onReady: () {
        _isPlayerReady = true;
      },
      onEnded: (data) {
        _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
        //_showSnackBar('Next Video Started!');
      },
    );
  }
}
