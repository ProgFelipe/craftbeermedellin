import 'package:craftbeer/components/story_telling.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeerReleases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Release> releases = Provider.of<List<Release>>(context);

    if(releases == null){ return LoadingWidget();}
    return storyTellingWidget(context, releases: releases);
  }
}
