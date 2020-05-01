import 'package:craftbeer/abstractions/beer_model.dart';
import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewers_detail_view.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/components/decoration_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final Function scrollViewToTop;
  SearchWidget(this.scrollViewToTop);

  Future<List<Map<dynamic, dynamic>>> getSuggestions(
      List<Brewer> brewers, List<Beer> beers, String query) async {
    if (query != null && query.length > 0) {
      List<Map<dynamic, dynamic>> brewersAndBeers = List();

      var brewersQueryResultList = brewers
          .where((brewer) =>
              brewer.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      brewersQueryResultList?.forEach((element) {
        brewersAndBeers.add({'name': element.name, Api.brewer: element.id});
      });
      var beersQueryResultList = beers
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      beersQueryResultList?.forEach((element) {
        brewersAndBeers
            .add({'name': element.name, Api.brewer: element.brewerId});
      });
      //return await db.searchBeers(query);
      return brewersAndBeers;
    }
    return List();
  }

  @override
  Widget build(BuildContext context) {
    var brewerProvider = Provider.of<BrewersData>(context);
    List<Brewer> brewers = brewerProvider.brewers;
    List<Beer> beers = brewerProvider.beers;

    if (brewers == null || beers == null) {
      return LoadingWidget();
    }
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(DecorationConsts.cardRadius),
        ),
      ),
      child: TypeAheadField(
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(DecorationConsts.cardRadius),
          elevation: 10.0,
        ),
        textFieldConfiguration: TextFieldConfiguration(
          onTap: scrollViewToTop,
          autofocus: false,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: DecorationConsts.hintGreyColor,
              ),
              hintText: S.of(context).find_beer_or_brewer_hint,
              hintStyle: TextStyle(color: DecorationConsts.hintGreyColor),
              border: InputBorder.none),
        ),
        suggestionsCallback: (pattern) async {
          //return await BackendService.getSuggestions(pattern);
          return await getSuggestions(brewers, beers, pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(BeerIcon.beerglass),
            title: Text(suggestion['name']),
            //subtitle: Text('\$${suggestion.data['type']}'),
          );
        },
        onSuggestionSelected: (suggestion) {
          /*var ref = suggestion.data[Api.brewer] != null
              ? suggestion.data[Api.brewer].documentID
              : suggestion.documentID;*/
          var ref = suggestion[Api.brewer];
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(
              brewerID: ref,
            ),
          ));
        },
      ),
    );
  }
}
