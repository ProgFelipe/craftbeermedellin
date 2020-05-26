import 'dart:convert';

import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/abstractions/store_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/ui/map/event_map_detail.dart';
import 'package:craftbeer/ui/map/store_map_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapNotifier extends ChangeNotifier {
  List<Store> _stores;
  List<Event> _events;
  Api api;
  bool eventsAdded = false;

  //Map<MarkerId, Marker> marker = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  bool _showDetailCard = false;
  Set<Marker> _markers = {};
  Widget moreDetails;

  get showDetail => _showDetailCard;

  setEvents(List<Event> events) async {
    _events = events;
    if (events != null && events.isNotEmpty && !eventsAdded) {
      eventsAdded = true;
      createEventsMarkers();
    }
  }

  get markers => _markers;

  void hideDetailBottomDialog() {
    _showDetailCard = false;
    notifyListeners();
  }

  MapNotifier() {
    this.api = Api();
    init();
  }

  init() async {
    _stores = await getStores();
    if (_stores.isNotEmpty) {
      createStoreMarkers();
    }
  }

  Future<List<Store>> getStores() async {
    try {
      var response = await api.fetchStores();
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        List<Store> stores = List();
        for (Map article in jsonData) {
          var articleObj = Store.fromJson(article);
          stores.add(articleObj);
        }
        return stores;
      }
      return List();
    } catch (exception, stacktrace) {
      print(stacktrace);
      return List();
    }
  }

  BitmapDescriptor marketIcon;

  final ImageConfiguration imageConfiguration =
      ImageConfiguration(devicePixelRatio: 1.5);

  Future<void> createStoreMarkers() async {
    final BitmapDescriptor pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/marker_beer.png');

    _stores?.forEach((store) {
      var marker = Marker(
          markerId: MarkerId(store.name),
          position: LatLng(store.latitude, store.longitude),
          icon: pinLocationIcon,
          infoWindow: InfoWindow(
              title: store.name,
              snippet: store.openHours,
              onTap: () {
                moreDetails = StoreMapMarketDetail(
                  store: store,
                );
                _showDetailCard = true;
                notifyListeners();
              }));
      _markers.add(marker);
    });
    notifyListeners();
  }

  Future<void> createEventsMarkers() async {
    final BitmapDescriptor pinLocationIcon =
        await BitmapDescriptor.fromAssetImage(
            imageConfiguration, 'assets/marker_event.png');

    var count = 0;
    _events?.forEach((event) {
      debugPrint("EVENT NAME: ${event.description}");
      if (event?.latitude != -1.0 && event?.longitude != -1.0) {
        var marker = Marker(
            markerId: MarkerId(count.toString()),
            position: LatLng(event.latitude, event.longitude),
            icon: pinLocationIcon,
            infoWindow: InfoWindow(
                title: event.description,
                onTap: () {
                  moreDetails = EventMapMarketDetail(
                    event: event,
                  );
                  _showDetailCard = true;
                  notifyListeners();
                }));
        _markers.add(marker);
        count++;
      }
    });
    notifyListeners();
  }
}
