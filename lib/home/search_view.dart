import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          autofocus: false,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: DecorationConsts.hintGreyColor,
              ),
              hintText: 'Busca tú Cerveza ó Cervecero',
              hintStyle: TextStyle(color: DecorationConsts.hintGreyColor),
              border: InputBorder.none),
        ),
        suggestionsCallback: (pattern) async {
          return await BackendService.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(BeerIcon.beerglass),
            title: Text(suggestion.data['name']),
            //subtitle: Text('\$${suggestion.data['type']}'),
          );
        },
        onSuggestionSelected: (suggestion) {
          var ref = suggestion.data[Api.brewer] != null
              ? suggestion.data[Api.brewer].documentID
              : suggestion.documentID;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(
              brewerRef: ref,
            ),
          ));
        },
      ),
    );
  }
}

class BackendService {
  static Future<List<DocumentSnapshot>> getSuggestions(String query) async {
    if (query != null && query.length > 0) {
      return await db.searchBeers(query);
    }
    return List();
  }
}


///Beers by local stream values
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail_view.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/components/decoration_constants.dart';
import 'package:craftbeer/api.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {

  static Future<List<Map<dynamic, dynamic>>> getSuggestions(List<Brewer> brewers,List<BeerType> categories, String query) async {
    if (query != null && query.length > 0) {
      var identifier = new Map();
      identifier['name'] = '';
      identifier['ref'] = '';
      List<Map<dynamic, dynamic>> brewersAndCategories = List();

      var brewersQueryResultList = brewers.where((brewer) => brewer.name.toLowerCase().contains(query.toLowerCase())).toList();
      brewersQueryResultList?.forEach((element) {
        brewersAndCategories.add( {'name': element.name, 'ref': element.id});
      });
      var categoriesQueryResultList = categories.where((category) => category.name.toLowerCase().contains(query.toLowerCase())).toList();
      categoriesQueryResultList?.forEach((element) {
        brewersAndCategories.add( {'name': element.name, 'ref': element.id});
      });
      //return await db.searchBeers(query);
      return brewersAndCategories;
    }
    return List();
  }

  @override
  Widget build(BuildContext context) {
    List<Brewer> brewers = Provider.of<List<Brewer>>(context);
    List<BeerType> categories = Provider.of<List<BeerType>>(context);

    if(brewers == null || categories == null){
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
          autofocus: false,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: DecorationConsts.hintGreyColor,
              ),
              hintText: 'Busca tú Cerveza ó Cervecero',
              hintStyle: TextStyle(color: DecorationConsts.hintGreyColor),
              border: InputBorder.none),
        ),
        suggestionsCallback: (pattern) async {
          return await getSuggestions(brewers, categories, pattern);
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
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BrewersDetail(
              brewerRef: suggestion['ref'],
            ),
          ));
        },
      ),
    );
  }
}

 */
