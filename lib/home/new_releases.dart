import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class BeerReleases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Release> releases = Provider.of<List<Release>>(context);

    if (releases == null) {
      return LoadingWidget();
    }
    List<StoryItem> stories = List();
    releases.forEach((release) {
      stories.add(StoryItem.inlineGif(
        release.imageUri,
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
}
