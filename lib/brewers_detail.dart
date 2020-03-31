import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

class BrewersDetail extends StatefulWidget {
  final int item;
  BrewersDetail(this.item);

  @override
  State<StatefulWidget> createState() {
    return BrewersDetailState();
  }
}

class BrewersDetailState extends State<BrewersDetail> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('brewers').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                //title: Text(widget.event.data['name'], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
                title: Text(''),
              ),
              body: Center(
                child: Text('There are no brewers loading...'),
              ));
        }
        return Scaffold(
          appBar: AppBar(
            //title: Text(widget.event.data['name'], style:  TextStyle(fontFamily: 'Faster', fontSize: 40.0),),
            title: Text("${snapshot.data.documents[widget.item]['name']}"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(
                      snapshot.data.documents[widget.item]['imageUri'],
                      width: 100.0,
                      fit: BoxFit.cover),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            snapshot.data.documents[widget.item]['description'],
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16.0),
                            maxLines: 5,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          FlatButton.icon(
                            color: Colors.green,
                            onPressed: () async {
                              var phone = '3117885174';
                              var whatsAppUrl = "whatsapp://send?phone=$phone";
                              FlutterOpenWhatsapp.sendSingleMessage(
                                  snapshot.data.documents[widget.item]['phone'],
                                  "Quiero una cerveza de ${snapshot.data.documents[widget.item]['name']} y me gustaría comprarte algunas\n[CraftBeer Colombia]");
                              // launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html'
                              // );
                            },
                            icon: Icon(Icons.phone),
                            label: RichText(
                              text: TextSpan(
                                text: 'Pedir Whatsapp',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.favorite,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TitleTextUtils('Nuestras Cervezas', Colors.black, 40.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: List.generate(
                    snapshot.data.documents[widget.item]['brewingOn'].length,
                    (index) => Container(
                      color: Colors.green,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                          '${snapshot.data.documents[widget.item]['brewingOn'][index]['name']}'),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
