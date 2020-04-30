import 'dart:async';
import 'dart:math';
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
  int _markerIdCounter = 1;
  bool _showDetailCard = false;

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconBeer == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/mapbeer.png')
          .then(_updateBeerBitmap);
    }
    if (_markerIconEvent == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/event.png')
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

  setCustomMapPin() async {
    return await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/beer.png')
        .then((value) => marketIcon = value);
  }

  @override
  void initState() {
    _showDetailCard = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                height: 280.0,
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'El mejor evento cervecero',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Este evento es patrocinado por los aguacates de Martinez',
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.restaurant, color: Colors.blue),
                                SizedBox(width: 10.0,),
                                Text('Nachos, Tacos, Fajas y Asados')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.queue_music, color: Colors.black38),
                                SizedBox(width: 10.0,),
                                Text('Banda en vivo')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(width: 10.0,),
                                Text('100')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.accessible_forward,
                                    color: Colors.lightGreen),
                                SizedBox(width: 10.0,),
                                Text('Fácil acceso')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.local_parking,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10.0,),
                                Text('Parking')
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.airport_shuttle),
                                SizedBox(width: 10.0,),
                                Text('Cerca a transporte público')
                              ],
                            ),
                          ],
                        ),
                        Image.asset('assets/event.gif', width: 145.0,),
                      ],
                    ),
                  ],
                ),
              ),
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
          });
        },
      )
    ].toSet();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    //  controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      icon: marketIcon,
      position: LatLng(
        _mapCenter.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
        _mapCenter.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
    );

    markers[markerId] = marker;
  }

  @override
  bool get wantKeepAlive => true;
}
