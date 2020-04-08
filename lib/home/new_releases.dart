import 'package:craftbeer/components/story_telling.dart';
import 'package:craftbeer/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeerReleases extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: storyTellingGenericWidget(context, stories: ['https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQgWaRb9Jlker_tsHpRCcRg99_enpOmhwN3V7htwzssv1gqF7C3&usqp=CAU',
      'https://cdn-az.allevents.in/banners/1bb65100-6064-11e9-9f9d-61122212aae4-rimg-w300-h300-gmir.jpg', 'https://scontent-lga3-1.cdninstagram.com/v/t51.2885-15/sh0.08/e35/s640x640/56412488_133156631082817_4147228610695158345_n.jpg?_nc_ht=scontent-lga3-1.cdninstagram.com&_nc_cat=101&_nc_ohc=la496YvB9vgAX-hRbXo&oh=0223c78364b31f1269052f7222b2e117&oe=5EB0C21A'],
      message: ['Quedate en casa',
        'Día de cervecero', '']),
    );

    /*Container(
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
    );*/
  }
}
