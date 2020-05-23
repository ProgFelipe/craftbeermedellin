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
  BitmapDescriptor _markerIconBeer;
  BitmapDescriptor _markerIconEvent;
  MarkerId selectedMarker;
  bool _showDetailCard = false;
  MapElementType _markerType;
  Set<Marker> _markers = {};
  bool storesAdded = false;
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
    _markerType = MapElementType.EVENT;
    super.initState();
  }

  Widget getMarkerDetailWidget() {
    switch (_markerType) {
      case MapElementType.EVENT:
        return EventMapMarketDetail(
          eventName: 'El mejor evento cervecero',
          eventDescription:
              'Este evento es patrocinado por los aguacates de Martinez asdasdajosdasdj oasdasjdasndasnd kandnasndlsa',
          foodDescription:
              'Nachos, Tacos, Frisoles, sdasdasdasda asdasdasdasdasdasdasdas s',
          capacity: 100,
          parkingLots: 4,
        );
      case MapElementType.STORE:
        return StoreMapMarketDetail(
            storeName: 'Pub Envigado',
            storeDescription: 'Somos un bar 100% cervecero');
    }
  }

  Future<void> createStoreMarkers(List<Store> stores) async {
    if (!storesAdded) {
      final ImageConfiguration imageConfiguration =
          ImageConfiguration(devicePixelRatio: 2.5);

      final BitmapDescriptor pinLocationIcon =
          await BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/marker_beer.png');

      stores.forEach((element) {
        var marker = Marker(
            markerId: MarkerId(element.name),
            position: LatLng(element.latitude, element.longitude),
            icon: pinLocationIcon,
            infoWindow: InfoWindow(
                title: element.name,
                snippet: element.openHours,
                onTap: () {
                  setState(() {
                    _moreDetails = StoreMapMarketDetail(
                      storeName: element.name,
                      publicTransport: element.publicTransport,
                      easyAccess: element.easyAccess,
                      storeDescription: element.openHours,
                      capacity: 100,
                      parkingLots: 4,
                    );
                    _showDetailCard = true;
                  });
                }));
        _markers.add(marker);
      });
      storesAdded = true;
      setState(() {});
    }
  }

  Future<void> createEventsMarkers(List<Event> events) async {
    final ImageConfiguration imageConfiguration =
        ImageConfiguration(devicePixelRatio: 1.5);

    final BitmapDescriptor pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/marker_event.png');

    events.forEach((element) {
      var marker = Marker(
          markerId: MarkerId(element.name),
          position: LatLng(
              double.parse(element.latitude), double.parse(element.longitude)),
          icon: pinLocationIcon);
      //_markers.add(marker);
    });
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
        //createEventsMarkers(events);
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
              child: Visibility(visible: _showDetailCard, child: _moreDetails ?? SizedBox()),
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
