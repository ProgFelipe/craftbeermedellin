import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

class Beer {
  final String name,
      description,
      history,
      imageUri,
      flavors,
      scents,
      ingredients,
      price;
  final int bitter, candy, salty, hotSpicy;
  final int id;
  final int brewerId;
  final int categoryId;
  final num abv, ibu, srm;
  final num ranking, votes;
  final Timestamp release;
  bool doITasted;
  int myVote;
  String myComment;
  final bool sell;

  /// IF HAS INVIMA AND IS AVAILABLE FOR SALE

  Beer(
      {this.id,
      this.name,
      this.brewerId,
      this.categoryId,
      this.description,
      this.history,
      this.abv,
      this.ibu,
      this.srm,
      this.myComment,
      this.doITasted,
      this.myVote,
      this.price,
      this.bitter,
      this.candy,
      this.salty,
      this.hotSpicy,
      this.flavors,
      this.scents,
      this.ingredients,
      this.imageUri,
      this.ranking,
      this.votes,
      this.release,
      this.sell});

  factory Beer.fromJson(Map<String, dynamic> data) {
    var beer = Beer(
        id: data['id'],
        name: data['name'] ?? '',
        categoryId: data['category'] ?? 0,
        brewerId: data['brewer'] ?? 0,
        description: data['description'] ?? '',
        history: data['history'] ?? '',
        abv: double.parse(data['abv']) ?? 0.0,
        ibu: double.parse(data['ibu']) ?? 0.0,
        srm: double.parse(data['srm']) ?? 0.0,
        imageUri: data['beer_pic'] ?? '',
        ranking: data['ranking'] ?? 0,
        votes: data['votes'] ?? 0,
        doITasted: false,
        price: data['price']?.toString() ?? '',
        bitter: data['bitter'] ?? 0,
        candy: data['candy'] ?? 0,
        salty: data['salty'] ?? 0,
        hotSpicy: data['hotSpicy'] ?? 0,
        release:
            Timestamp.fromDate(DateTime.parse(data['release_date'])) ?? null,
        sell: data['on_sale'] ?? false,
        flavors: data['flavors'] ?? '',
        scents: data['scents'] ?? '',
        ingredients: data['ingredients'] ?? '');
    return beer;
  }

  Map<String, dynamic> toDaoMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'history': history,
      'abv': abv,
      'ibu': ibu,
      'srm': srm,
      'imageUri': imageUri,
      'ranking': ranking,
      'price': price,
      'votes': votes,
      'tasted': doITasted == true ? 1 : 0,
      'my_vote': myVote ?? 0,
      'comment': myComment ?? '',
      'release': dateFormat.format(release.toDate()),
      'sell': sell ? 1 : 0,
      'flavors': flavors,
      'scents': scents,
      'ingredients': ingredients,
      'categoryId': categoryId,
      'brewerId': brewerId,
      'bitter': bitter,
      'candy': candy,
      'salty': salty,
      'hotSpicy': hotSpicy,
    };
  }

  factory Beer.fromDB(Map<String, dynamic> data) {
    var beer = Beer(
        id: data['id'],
        name: data['name'] ?? '',
        categoryId: data['categoryId'] ?? 0,
        brewerId: data['brewerId'] ?? 0,
        description: data['description'] ?? '',
        history: data['history'] ?? '',
        abv: data['abv'] ?? 0.0,
        ibu: data['ibu'] ?? 0.0,
        srm: data['srm'] ?? 0.0,
        price: data['price'] ?? '',
        bitter: data['bitter'] ?? 0,
        candy: data['candy'] ?? 0,
        salty: data['salty'] ?? 0,
        hotSpicy: data['hotSpicy'] ?? 0,
        imageUri: data['beer_pic'] ?? '',
        ranking: data['ranking'] as num ?? 0,
        votes: data['votes'] ?? 0,
        doITasted: data['tasted'] == 1 ? true : false,
        myVote: data['myVote'] ?? 0,
        myComment: data['comment'] ?? '',
        release: Timestamp.fromDate(DateTime.parse(data['release'])) ?? null,
        sell: data['sell'] == 1 ? true : false,
        flavors: data['flavors'] ?? '',
        scents: data['scents'] ?? '',
        ingredients: data['ingredients'] ?? '');
    return beer;
  }
}
