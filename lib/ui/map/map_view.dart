import 'dart:async';
import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/providers/map_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CraftMap extends StatefulWidget {
  @override
  _CraftMapState createState() => _CraftMapState();
}

class _CraftMapState extends State<CraftMap>
    with AutomaticKeepAliveClientMixin<CraftMap> {

  Completer<GoogleMapController> _controller = Completer();

  //Valle del Aburra
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.2291968, -75.5859456),
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MapNotifier>(builder: (context, mapNotifier, child) {
      List<Event> events = Provider.of<List<Event>>(context);
      mapNotifier.setEvents(events);
      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onTap: (LatLng pos) {
                mapNotifier.hideDetailBottomDialog();
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: mapNotifier.markers,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                  visible: mapNotifier.showDetail,
                  child: mapNotifier.moreDetails ?? SizedBox()),
            )
          ],
        ),
      );
    });
    //_createMarkerImageFromAsset(context);
  }

  @override
  bool get wantKeepAlive => true;
}
