import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/connectivity_widget.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ConnectivityWidget(),
                SizedBox(height: 20.0,),
                CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white, size: 80.0,),
                  backgroundColor: Colors.grey,
                  radius: 60.0,
                ),
                SizedBox(height: 20.0,),
                Container(
                  width: double.infinity,
                    child: FlatButton.icon(onPressed: (){}, icon: Icon(BeerIcon.google), label: Text('Ingresa'), color: Colors.orange,)),
                SizedBox(height: 20.0,),
                Text('Registrate para poder calificar y comentar sobre las cervezas que probaste, ver tús cervezas favoritas y recomendarlas, adquirir beneficios, descuentos en boletas, promociones en cervezas y mucho más, o si deseas saber cuando tú cervecero'
                    'saca una nueva variedad de cerveza,, ', textAlign: TextAlign.justify,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
