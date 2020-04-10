import 'package:connectivity/connectivity.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityWidget extends StatelessWidget {
  Widget internetErrorWidget(context) {
    return Container(
      width: double.infinity,
      height: 40.0,
      color: Colors.redAccent,
      child: Center(
        child: Text(
          S.of(context).no_data,
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
    ConnectivityResult connectivityResult = Provider.of<ConnectivityResult>(context);

    if (connectivityResult == null) return SizedBox();
    switch(connectivityResult){
      case ConnectivityResult.none:
        return internetErrorWidget(context);
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return SizedBox();
      default:
        return internetErrorWidget(context);
    }
  }
}
