import 'package:cloud_firestore/cloud_firestore.dart';

class Beer {
  final String id,
      name,
      description,
      history,
      brewerRef,
      imageUri,
      type,
      flavors,
      scents,
      ingredients;
  final num abv, ibu, srm;
  final num ranking, votes;
  final Timestamp release;
  final bool sell; /// IF HAS INVIMA AND IS AVAILABLE FOR SALE
  Beer(
      {this.id,
        this.name,
        this.brewerRef,
        this.description,
        this.history,
        this.abv,
        this.ibu,
        this.srm,
        this.flavors,
        this.scents,
        this.ingredients,
        this.imageUri,
        this.ranking,
        this.votes,
        this.release,
        this.sell,
        this.type});

  factory Beer.fromMap(DocumentSnapshot data) {
    var beer = Beer(
        id: data?.documentID ?? '',
        name: data['name'] ?? '',
        brewerRef: data['brewer']?.documentID ?? '',
        description: data['description'] ?? '',
        history: data['history'] ?? '',
        abv: data['abv']?.toDouble() ?? 0.0,
        ibu: data['ibu']?.toDouble() ?? 0.0,
        imageUri: data['imageUri'] ?? '',
        ranking: data['ranking'] as num ?? 0,
        votes: data['votes'] ?? 0,
        release: data['release'] ?? null,
        sell: data['sell'] ?? false,
        type: data['type']?.documentID ?? '');
    return beer;
  }

  factory Beer.fromJson(Map<String, dynamic> data) {
    var beer = Beer(
        id: data['name'] ?? '',
        name: data['name'] ?? '',
        brewerRef: data['brewer']?.toString() ?? '',
        description: data['description'] ?? '',
        history: data['history'] ?? '',
        abv: double.parse(data['abv']) ?? 0.0,
        ibu: double.parse(data['ibu']) ?? 0.0,
        srm: double.parse(data['srm']) ?? 0.0,
        imageUri: data['beer_pic'] ?? '',
        ranking: data['ranking'] as num ?? 0,
        votes: data['votes'] ?? 0,
        release:
        Timestamp.fromDate(DateTime.parse(data['release_date'])) ?? null,
        sell: data['sell'] ?? false,
        flavors: data['flavors'] ?? '',
        scents: data['scents'] ?? '',
        ingredients: data['ingredients'] ?? '',
        type: data['category']?.toString() ?? '');
    return beer;
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description':  description,
      'history': history,
      'abv': abv,
      'ibu': ibu,
      'srm': srm,
      'imageUri': imageUri,
      'ranking': ranking,
      'votes': votes,
      'release': release,
      'sell': sell,
      'flavors': flavors,
      'scents': scents,
      'ingredients': ingredients,
      'category': type};
  }
}