import 'dart:async';
import 'package:craftbeer/providers/map_data_notifier.dart';
import 'package:craftbeer/ui/map/event_map_detail.dart';
import 'package:craftbeer/ui/map/store_map_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CraftMap extends StatefulWidget {
  @override
  _CraftMapState createState() => _CraftMapState();
}

class _CraftMapState extends State<CraftMap>
    with AutomaticKeepAliveClientMixin<CraftMap> {
  //Valle del Aburra
  static final LatLng _mapCenter = const LatLng(6.243455, -75.7482963);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor _markerIconBeer;
  BitmapDescriptor _markerIconEvent;
  MarkerId selectedMarker;
  bool _showDetailCard = false;
  MapElementType _markerType;

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconBeer == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/marker_beer.png')
          .then(_updateBeerBitmap);
    }
    if (_markerIconEvent == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/marker_event.png')
          .then(_updateEventBitmap);
    }
  }

  void _updateBeerBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconBeer = bitmap;
    });
  }

  void _updateEventBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIconEvent = bitmap;
    });
  }

  Completer<GoogleMapController> _controller = Completer();

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
  
  Widget getMarkerDetailWidget(){
    switch(_markerType){
      case MapElementType.EVENT: return EventMapMarketDetail(eventName: 'El mejor evento cervecero', eventDescription: 'Este evento es patrocinado por los aguacates de Martinez asdasdajosdasdj oasdasjdasndasnd kandnasndlsa', foodDescription: 'Nachos, Tacos, Frisoles, sdasdasdasda asdasdasdasdasdasdasdas s', capacity:  100, parkingLots:  4,);
      case MapElementType.STORE: return StoreMapMarketDetail(storeName: 'Pub Envigado', storeDescription: 'Somos un bar 100% cervecero');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _createMarkerImageFromAsset(context);

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
            markers: _createMarker(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Visibility(
              visible: _showDetailCard,
              child: getMarkerDetailWidget()
            ),
          )
        ],
      ),
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: _mapCenter,
        icon: _markerIconBeer,
        //infoWindow: InfoWindow(title: 'Cerveza Guardian', snippet: 'La fonda de Luigi'),
        onTap: () {
          setState(() {
            _showDetailCard = !_showDetailCard;
            _markerType = MapElementType.STORE;
          });
        },
      ),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(_mapCenter.latitude + 0.1, _mapCenter.longitude),
        icon: _markerIconEvent,
        //infoWindow: InfoWindow(title: 'Evento Cerveza Guardian', snippet: 'Donde Las primas de Martins'),
        onTap: () {
          setState(() {
            _showDetailCard = !_showDetailCard;
            _markerType = MapElementType.EVENT;
          });
        },
      )
    ].toSet();
  }

  @override
  bool get wantKeepAlive => true;
}
