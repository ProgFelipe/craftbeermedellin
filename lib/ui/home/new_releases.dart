import 'package:craftbeer/abstractions/release_model.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Release> releases = Provider.of<List<Release>>(context);
    final StoryController controller = StoryController();

    if (releases == null) {
      return LoadingWidget();
    }
    List<StoryItem> stories = List();
    releases.forEach((release) {
      stories.add(StoryItem.inlineImage(
        url: release.imageUri,
        controller: controller,
        roundedTop: false,
        imageFit: BoxFit.fitHeight,
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
            controller: controller,
            storyItems: stories,
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
}
