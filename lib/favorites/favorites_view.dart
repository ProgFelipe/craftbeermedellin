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

  Future<List<String>> _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('favorites') ?? List());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: Text('Fetching favorites..'));
          }
          if (snapshot.data.length == 0) {
            return SafeArea(
              child: Container(
                height: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
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
                    SizedBox(height: 20.0),
                    Text(
                      'Agrega Favoritos',
                      style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                  ],
                ),
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
                    Container(
                        height: double.infinity,
                        child: Image.asset(
                          'assets/icon.png',
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                              if (index == 0) {
                                return FavoriteCard(
                                    imageUri: 'assets/girlgif2.gif',
                                    title: 'Guardian');
                              }
                              if (index == 1) {
                                return FavoriteCard(
                                  imageUri: 'assets/girlgif.gif',
                                  title: 'Madre Monte',
                                );
                              }
                              return FavoriteCard(
                                imageUri: 'assets/beertype.png',
                              );
                              /*Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              favorites[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ));*/
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
