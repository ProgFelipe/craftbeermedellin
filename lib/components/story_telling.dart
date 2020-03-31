import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

Widget storyTellingWidget() {
  return Container(
    height: 300,
    child: StoryView(
      [
        StoryItem.text(
          "Bienvenido\nBrewers Colombia.!\n\nLa cerveza artesanal es nuestra pasión \n\nConoce sobre cercezas artesanales locales!",
          Colors.amber,
          roundedTop: true,
        ),
        // StoryItem.inlineImage(
        //   NetworkImage(
        //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
        //   caption: Text(
        //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
        //     style: TextStyle(
        //       color: Colors.white,
        //       backgroundColor: Colors.black54,
        //       fontSize: 17,
        //     ),
        //   ),
        // ),
        /*StoryItem.inlineImage(
          NetworkImage(
              "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg"),
          caption: Text(
            "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
            style: TextStyle(
              color: Colors.white,
              backgroundColor: Colors.black54,
              fontSize: 17,
            ),
          ),
        ),*/
        StoryItem.inlineGif(
          "https://media.giphy.com/media/zXubYhkWFc9uE/giphy.gif",
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
          "https://media.giphy.com/media/Zw3oBUuOlDJ3W/giphy.gif",
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
          "https://media.giphy.com/media/J0ySNzZ5APILC/giphy.gif",
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
          "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
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
      inline: true,
    ),
  );
}
