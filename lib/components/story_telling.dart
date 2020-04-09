import 'package:craftbeer/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

Widget storyTellingWidget(context,
    {List<Release> releases}) {
  List<StoryItem> stories = List();
  releases.forEach((release) {
    stories.add(StoryItem.inlineGif(
      release.imageUri,
      roundedTop: false,
      imageFit: BoxFit.scaleDown,
      caption: Text(
        release.name,
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