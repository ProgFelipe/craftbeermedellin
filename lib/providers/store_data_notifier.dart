import 'dart:convert';

import 'package:craftbeer/abstractions/store_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/base_provider.dart';

class StoreData extends BaseProvider {
  final api = DataBaseService();
  var stores = List<Store>();

  StoreData() {
    fetchStores();
  }

  Future<void> fetchStores() async {
    showLoading();
    try {
      var response = await api.fetchStores();
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        for (Map article in jsonData) {
          var articleObj = Store.fromJson(article);
          stores.add(articleObj);
        }
      }
      hideLoading();
    } catch (exception, stacktrace) {
      print(stacktrace);
      hideLoading();
    }
  }

  @override
  void dispose() {
    super.dispose();

    stores.clear();
  }
}
