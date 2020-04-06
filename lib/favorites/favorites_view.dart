import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/favorites/favorite_brewer_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key key}) : super(key: key);

  //final AsyncMemoizer _memoizer = AsyncMemoizer();

  /*@override
  void didUpdateWidget(FutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.future != widget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }*/

  Future<List<String>> getFutureFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorites') ?? List();
  }

  Stream<List<String>> _getFavorites() {
    return Stream.fromFuture(getFutureFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.data.length == 0) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(
                          BeerIcon.beerglass,
                          size: 80.0,
                          color: Colors.grey,
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: Icon(
                            Icons.favorite,
                            size: 40.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Agrega Favoritos',
                    style: TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [Colors.black, Colors.blueGrey],
                ),
              ),
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    //Background
                    Container(
                        height: double.infinity,
                        child: Image.asset(
                          'assets/icon.png',
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ConnectivityWidget(),
                        SizedBox(
                          height: 40.0,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 40.0,
                          ),
                          title: Text(
                            'Favoritos',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontFamily: 'Patua',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return FavoriteCard(
                                brewerId: snapshot.data[index],
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
