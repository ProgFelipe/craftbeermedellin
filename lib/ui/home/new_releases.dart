import 'package:craftbeer/abstractions/release_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

class News extends StatelessWidget {
  final StoryController controller = StoryController();

  Future<List<StoryItem>> fetchStories(List<Release> releases) async {
    return releases.map((release) {
          return StoryItem.inlineImage(
            url: release.imageUri,
            controller: controller,
            duration: Duration(seconds: 5),
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
          );
        }).toList() ??
        List();
  }

  @override
  Widget build(BuildContext context) {
    List<Release> releases = Provider.of<List<Release>>(context);
    if (releases == null) {
      return LoadingWidget();
    }
    if (releases.isNotEmpty) {
      return FutureBuilder(
          future: fetchStories(releases),
          builder: (context, snapshot) {
            if (!snapshot.hasData && snapshot.data == null) {
              return LoadingWidget();
            }
            return Container(
                height: 240,
                child: StoryView(
                  controller: controller,
                  storyItems: snapshot.data,
                  progressPosition: ProgressPosition.bottom,
                  repeat: true,
                ));
          });
    } else {
      return Text(
        S.of(context).empty_state_news,
        style: TextStyle(color: kGrayEmptyState),
      );
    }
  }
}
