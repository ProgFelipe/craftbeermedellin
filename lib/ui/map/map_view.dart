import 'dart:async';
import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/abstractions/store_model.dart';
import 'package:craftbeer/providers/store_data_notifier.dart';
import 'package:craftbeer/ui/map/event_map_detail.dart';
import 'package:craftbeer/ui/map/store_map_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CraftMap extends StatefulWidget {
  @override
  _CraftMapState createState() => _CraftMapState();
}

class _CraftMapState extends State<CraftMap>
    with AutomaticKeepAliveClientMixin<CraftMap> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  bool _showDetailCard = false;
  Set<Marker> _markers = {};
  bool _storesAdded = false;
  bool _eventsAdded = false;
  Widget _moreDetails;

  Completer<GoogleMapController> _controller = Completer();

  //Valle del Aburra
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.2291968, -75.5859456),
    zoom: 10,
  );

  BitmapDescriptor marketIcon;

  @override
  void initState() {
    _showDetailCard = false;
    super.initState();
  }

  Future<void> createStoreMarkers(List<Store> stores) async {
    if (!_storesAdded) {
      final ImageConfiguration imageConfiguration =
          ImageConfiguration(devicePixelRatio: 2.5);

      final BitmapDescriptor pinLocationIcon =
          await BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/marker_beer.png');

      stores.forEach((store) {
        var marker = Marker(
            markerId: MarkerId(store.name),
            position: LatLng(store.latitude, store.longitude),
            icon: pinLocationIcon,
            infoWindow: InfoWindow(
                title: store.name,
                snippet: store.openHours,
                onTap: () {
                  setState(() {
                    _moreDetails = StoreMapMarketDetail(
                      store: store,
                    );
                    _showDetailCard = true;
                  });
                }));
        _markers.add(marker);
      });
      _storesAdded = true;
      setState(() {});
    }
  }

  Future<void> createEventsMarkers(List<Event> events) async {
    debugPrint("==EVENTOS EN MAPA== ::>> $_eventsAdded");

    if(!_eventsAdded) {
      final ImageConfiguration imageConfiguration =
      ImageConfiguration(devicePixelRatio: 1.5);

      final BitmapDescriptor pinLocationIcon =
      await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/marker_event.png');

      var count = 0;
      events.forEach((event) {
        debugPrint("EVENT NAME: ${event.description}");
        if (event?.latitude != -1.0 && event?.longitude != -1.0) {
          var marker = Marker(
              markerId: MarkerId(count.toString()),
              position: LatLng(event.latitude, event.longitude),
              icon: pinLocationIcon,
              infoWindow: InfoWindow(
                  title: event.description,
                  onTap: () {
                    setState(() {
                      _moreDetails = EventMapMarketDetail(
                        event: event,
                      );
                      _showDetailCard = true;
                    });
                  }));
          _markers.add(marker);
          count++;
        }
      });
      _eventsAdded = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Event> events = Provider.of<List<Event>>(context);
    return Consumer<StoreData>(builder: (context, storeData, child) {
      if (storeData.stores != null || storeData.stores.isNotEmpty) {
        createStoreMarkers(storeData.stores);
      }

      if (events != null && events.isNotEmpty) {
        createEventsMarkers(events);
      }

      return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onTap: (LatLng pos) {
                setState(() {
                  _showDetailCard = false;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                  visible: _showDetailCard, child: _moreDetails ?? SizedBox()),
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
