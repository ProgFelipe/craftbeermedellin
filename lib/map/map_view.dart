import 'package:craftbeer/components/image_provider.dart';
import 'package:flutter/material.dart';

class CraftMap extends StatefulWidget {
  @override
  _CraftMapState createState() => _CraftMapState();
}

class _CraftMapState extends State<CraftMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        width: double.infinity,
        height: double.infinity,
        child: Image.asset('assets/map.jpeg',fit: BoxFit.fill,),
      ),
    );
  }
}
