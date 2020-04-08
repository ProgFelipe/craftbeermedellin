import 'package:craftbeer/components/story_telling.dart';
import 'package:craftbeer/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeerReleases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: db.fetchReleases(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
            return storyTellingWidget(context, beersSnapshot: snapshot.data);
            //titleView('Releases'),
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
