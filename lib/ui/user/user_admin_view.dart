import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:  Colors.black87,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConnectivityWidget(),
                SizedBox(height: 20.0,),
                Image.asset('assets/icon.png', height: 120.0,),
                SizedBox(height: 20.0,),
                Container(
                  height: 50.0,
                  width: double.infinity,
                    child: FlatButton.icon(onPressed: (){}, icon: Icon(BeerIcon.google), label: Text('INGRESA', style: TextStyle(fontSize: 20.0),), color: Colors.green,)),
                SizedBox(height: 20.0,),
                titleView('Ingresa y obten estos beneficios:'),
                ListTile(
                  leading: MyBullet(),
                  title: Text('Ingresa para poder calificar y comentar sobre las cervezas que probaste'),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text('Ver tús cervezas favoritas y recomendarlas'),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text('Adquirir beneficios, descuentos en boletas, promociones en cervezas'),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text('Recibir notificaciones (cuando tú cervecero saca una nueva variedad de cerveza, eventos, beneficios solo para tí)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
