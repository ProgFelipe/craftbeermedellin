import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/image_provider.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/cupertino.dart';
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

    if (brewersData.loadingState) {
      return LoadingWidget();
    }
    if(brewersData.brewers == null || brewersData.brewers.isEmpty){
      return Text(S.of(context).empty_state_brewers, style: TextStyle(color: Colors.grey[500]),);
    }
    return Container(
      height: 100.0,
      alignment: Alignment.topLeft,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: brewersData.brewers.length,
        itemBuilder: (context, index) {
          var brewer = brewersData.brewers[index];
          return ChangeNotifierProvider<Brewer>.value(
            value: brewer,
            child: BrewerItem((brewer) {
              brewersData.currentBrewer = brewer;
            }),
          );
        },
      ),
    );
  }
}

class BrewerItem extends StatelessWidget {
  final Function changeCurrentBrewerOnTap;

  BrewerItem(this.changeCurrentBrewerOnTap);

  @override
  Widget build(BuildContext context) {
    var brewer = Provider.of<Brewer>(context);

    if (brewer == null) {
      return LoadingWidget();
    }
    return GestureDetector(
      onTap: () {
        changeCurrentBrewerOnTap(brewer);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrewersDetail(
                    brewerId: brewer.id,
                  )),
        );
      },
      child: Container(
        decoration: _brewersDecoration(),
        child: Stack(
          children: <Widget>[
            Hero(
                tag: brewer.name,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90.0),
                  child: ImageProviderWidget(
                    brewer.imageUri,
                  ),
                )),
            Positioned(
              bottom: 7.0,
              right: 5.0,
              child: Icon(
                (brewer?.favorite ?? false)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 30.0,
                color: kCitrusEndCustomColor,
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
    color: kWhiteColor,
  );
}
