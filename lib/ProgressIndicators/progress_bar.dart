import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProgressBarState();
  }
}

class ProgressBarState extends State<ProgressBar>{
  @override
  Widget build(BuildContext context) {
    return _createLinearProgressBar();
  }

  Widget _createLinearProgressBar(){
    return LinearProgressIndicator(
      backgroundColor: Colors.lightBlue,
      value: 60.0,);
  }

}