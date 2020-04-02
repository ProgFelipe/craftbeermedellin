import 'package:craftbeer/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

const List<String> gifs = [
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
];

Widget storyTellingWidget(context,
    {bool home = false,
    List<String> imagesOrGif = gifs,
    List<String> descriptions = defaultDescriptions}) {
  List<StoryItem> _createStoryItems() {
    List<StoryItem> stories = List();
    if (home) {
      stories.add(StoryItem.text(
        localizedText(context, WELCOME),
        Colors.amber,
        roundedTop: true,
        duration: Duration(milliseconds: 2000),
      ));
    }
    imagesOrGif.asMap().forEach((index, element) {
      stories.add(StoryItem.inlineGif(
        imagesOrGif[index],
        caption: Text(
          descriptions[index] ?? '',
          style: TextStyle(
            color: Colors.white,
            backgroundColor: Colors.black54,
            fontSize: 17,
          ),
        ),
      ));
    });
    return stories;
  }

  return Container(
    height: 240,
    child: StoryView(
      _createStoryItems(),
      progressPosition: ProgressPosition.bottom,
      repeat: true,
    ),
  );
}
