import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './ProgressIndicators/progress_bar.dart';

class BrewersDetail extends StatefulWidget {
  final int item;
  BrewersDetail(this.item);

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState();
  }
}

class BrewersDetailState extends State<BrewersDetail>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.event.data['name'], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
        title: Text('temp'),
      ),
      body: Center(
          child:  StreamBuilder(
            stream: Firestore.instance.collection('brewers').snapshots(),
            builder: (context, snapshot){
            if(!snapshot.hasData){ return Text('There are no brewers loading...');}
            return  Column(
            mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                   Text(snapshot.data.documents[widget.item]['name']),
                   Row(
                    children: <Widget>[
                       Image.network(snapshot.data.documents[widget.item]['imageUri'], fit: BoxFit.cover),
                       Text(snapshot.data.documents[widget.item]['description'],
                      textAlign: TextAlign.center, maxLines: 5, overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                   Text('More information Web Site'),
                   ProgressBar()
                ],
              );
            })
        ),
    );
  }
}