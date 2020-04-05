import 'package:craftbeer/components/story_telling.dart';
import 'package:craftbeer/repository/api.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeerReleases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: db.fetchReleases(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                titleView('Releases'),
                storyTellingWidget(context, beersSnapshot: snapshot.data)
              ],
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
