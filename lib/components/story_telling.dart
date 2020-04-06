import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

/*const List<String> gifs = [
  "https://media.giphy.com/media/zXubYhkWFc9uE/giphy.gif",
  "https://media.giphy.com/media/Zw3oBUuOlDJ3W/giphy.gif",
  "https://media.giphy.com/media/J0ySNzZ5APILC/giphy.gif",
  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif"
];

const List<String> defaultDescriptions = [
  "Que es esto?",
  "No lo se pero Salud!!",
  "https://media.giphy.com/media/J0ySNzZ5APILC/giphy.gif",
  "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif"
];*/

Widget storyTellingWidget(context,
    {bool home = false, QuerySnapshot beersSnapshot}) {
  debugPrint('Releases: ${beersSnapshot.documents}');
  List<StoryItem> stories = List();
  beersSnapshot.documents.forEach((beerItem) {
    stories.add(StoryItem.inlineGif(
      beerItem['imageUri'] ?? '',
      roundedTop: false,
      imageFit: BoxFit.scaleDown,
      caption: Text(
        beerItem['name'] ?? '',
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.black54,
          fontSize: 17,
        ),
      ),
    ));
  });
  if (stories.isNotEmpty) {
    return Container(
        height: 240,
        child: StoryView(
          stories,
          progressPosition: ProgressPosition.bottom,
          repeat: false,
        ));
  } else {
    return Text(
      'No New Releases',
      style: TextStyle(color: Colors.grey[500]),
    );
  }
}
