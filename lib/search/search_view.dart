import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail.dart';
import 'package:craftbeer/components/beer_icon_icons.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      /**
       * ListTile(
          leading: Icon(Icons.search),
          title: Text(
          'Buscar cerveza',
          style: TextStyle(color: Colors.grey[400]),
          )),
       */
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          autofocus: false,
          style: TextStyle(fontSize: 20.0),
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Busca tú Cerveza ó Cervecero',
              border: InputBorder.none),
        ),
        suggestionsCallback: (pattern) async {
          return await BackendService.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: Icon(BeerIcon.beerglass),
            title: Text(suggestion.data['name']),
            //subtitle: Text('\$${suggestion.data['abv']}'),
          );
        },
        onSuggestionSelected: (suggestion) {
          var ref = suggestion.data[Api.brewer] != null
              ? suggestion.data[Api.brewer].documentID
              : suggestion.documentID;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => BrewersDetail(ref)));
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
