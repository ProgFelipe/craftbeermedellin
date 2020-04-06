import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityWidget extends StatelessWidget {
  Widget internetErrorWidget(context) {
    return Container(
      width: double.infinity,
      height: 40.0,
      color: Colors.redAccent,
      child: Center(
        child: Text(
          localizedText(context, NO_DATA_ERROR),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Fires whenever the connectivity state changes.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
          if (!snapshot.hasData) return SizedBox();
          var result = snapshot.data;
          switch (result) {
            case ConnectivityResult.none:
              return internetErrorWidget(context);
            case ConnectivityResult.mobile:
            case ConnectivityResult.wifi:
              return SizedBox();
            default:
              return internetErrorWidget(context);
          }
        });
  }
}
