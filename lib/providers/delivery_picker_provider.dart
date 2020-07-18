import 'package:craftbeer/abstractions/delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kFirstAddress = "FirstDeliveryData";

class DeliveryPickerData extends ChangeNotifier {
  String baseUri = "https://www.google.com/maps/search/?api=1&query=";
  String deliveryGoogleMapUri =
      "https://www.google.com/maps/search/?api=1%26query=";

  SharedPreferences prefs;

  final delivery = Delivery();

  Future<SharedPreferences> getSharedPreference() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs;
  }

  String getDeliveryMapsUri() {
    return deliveryGoogleMapUri + "${delivery.latitude},${delivery.longitude}";
  }

  void saveAddress() async {
    SharedPreferences prefs = await getSharedPreference();
    prefs.setString(kFirstAddress,
        "${delivery.address.replaceAll('#', '%23').replaceAll('-', '%2D')},${delivery.description},${delivery.latitude},${delivery.longitude}");
  }

  Future<String> fetchDeliveryData() async {
    SharedPreferences prefs = await getSharedPreference();
    return prefs.getString(kFirstAddress);
  }

  Future<bool> preFillDataIfExist() async {
    String value = await fetchDeliveryData();
    if (value != null) {
      var elements = value.split(',');
      if (elements.length == 4) {
        delivery.address = elements[0];
        delivery.description = elements[1];
        delivery.latitude = elements[2];
        delivery.longitude = elements[3];
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
