import 'package:craftbeer/providers/base_provider.dart';
import 'package:flutter/material.dart';

class FailureStatusHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ErrorStatusWidget extends StatelessWidget {
  final BaseProvider baseProvider;

  const ErrorStatusWidget({Key key, this.baseProvider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(baseProvider.underMaintainState ){
      return Text('Estamos en mantenimiento!!', style: TextStyle(color: Colors.yellowAccent));
    }
    if(baseProvider.errorStatus){
      return Text('Ocurrío un error', style: TextStyle(color: Colors.redAccent),);
    }
    if(baseProvider.checkYourInternet){
      return Text('No pudimos cargar la información, es posible que no tengas buen internet!!', style: TextStyle(color: Colors.orange),);
    }
  }
}
