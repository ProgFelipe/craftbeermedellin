import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewersGrid extends StatefulWidget {
  @override
  _BrewersGridState createState() => _BrewersGridState();
}

class _BrewersGridState extends State<BrewersGrid> {
  List<String> favorites = [];
  bool favoriteOnDemand;

  bool isFavorite(String brewer) {
    return favorites.contains(brewer);
  }

  @override
  void initState() {
    debugPrint('INIT STATE BREWER GRID');
    super.initState();
  }

  @override
  void dispose() {
    debugPrint('DISPOSE STATE BREWER GRID');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brewersData = Provider.of<BrewersData>(context);
    //brewersData.getBrewers();
    var brewers = brewersData.brewers;

    if(brewersData.underMaintain){
      return Text('Estamo en mantenimiento');
    }
    if(brewersData.checkYourInternet){
      return Text('Revisa tú conexión a internet',);
    }
    if(brewersData.errorStatus){
      return Text('Ah ocurrido un error', style: TextStyle(color: Colors.red));
    }
    if (brewers == null || brewers.length == 0) {
      return LoadingWidget();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemCount: brewers.length,
        itemBuilder: (context, index) {
          var brewer = brewers[index];
          return ChangeNotifierProvider<Brewer>.value(
            value: brewer,
            child: BrewerItem(),
          );
        },
      ),
    );
  }
}

class BrewerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brewer = Provider.of<Brewer>(context);

    if (brewer == null) {
      return LoadingWidget();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrewersDetail(
                    brewer: brewer,
                  )),
        );
      },
      child: Container(
        decoration: _brewersDecoration(),
        margin: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            ImageProviderWidget(brewer.imageUri),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Icon(
                (brewer?.favorite ?? false)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 40.0,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _brewersDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(90.0),
    ),
    gradient: LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: [Colors.black, Colors.white.withOpacity(0.4)],
    ),
  );
}
