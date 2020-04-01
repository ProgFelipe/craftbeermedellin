import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BaseView extends StatefulWidget {
  static const String NO_INTERNET_CONNECTION = 'ConnectivityResult.none';

  @override
  State<StatefulWidget> createState() {
    return BaseViewState();
  }
}

class BaseViewState<T> extends State<BaseView> {
  String connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  bool isOffline = false;

  void initInternetValidation() {
    var online = connectionStatus == BaseView.NO_INTERNET_CONNECTION;
    if (isOffline != online) {
      setState(() {
        isOffline = online;
      });
    }
  }

  Widget errorWidget() {
    return isOffline
        ? Container(
            width: double.infinity,
            height: 40.0,
            color: Colors.redAccent,
            child: Center(
              child: Text(
                localizedText(context, NO_DATA_ERROR),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        : SizedBox();
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() => connectionStatus = result.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      connectionStatus = connectionStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
