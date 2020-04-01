import 'package:craftbeer/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

Widget storyTellingWidget(context) {
  final List<String> gifs = [
    "https://media.giphy.com/media/zXubYhkWFc9uE/giphy.gif",
    "https://media.giphy.com/media/Zw3oBUuOlDJ3W/giphy.gif",
    "https://media.giphy.com/media/J0ySNzZ5APILC/giphy.gif",
    "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif"
  ];

  return Container(
    height: 240,
    child: StoryView(
      [
        StoryItem.text(
          localizedText(context, WELCOME),
          Colors.amber,
          roundedTop: true,
          duration: Duration(milliseconds: 2000),
        ),
        StoryItem.inlineGif(
          gifs[0],
          caption: Text(
            "Que es esto?",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
        StoryItem.inlineGif(
          gifs[1],
          caption: Text(
            "No lo se pero Salud!!",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
        StoryItem.inlineGif(
          gifs[2],
          caption: Text(
            "Ooooh siiii!!",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),
        StoryItem.inlineGif(
          gifs[3],
          caption: Text(
            "Me encantaaaa",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        )
      ],
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
      },
      progressPosition: ProgressPosition.bottom,
      repeat: false,
    ),
  );
}
