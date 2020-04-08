import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

Widget storyTellingWidget(context,
    {bool home = false, QuerySnapshot beersSnapshot}) {
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
          progressPosition: ProgressPosition.top,
          repeat: false,
        ));
  } else {
    return Text(
      'No New Releases',
      style: TextStyle(color: Colors.grey[500]),
    );
  }
}
