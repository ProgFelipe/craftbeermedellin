import 'package:craftbeer/abstractions/release_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import 'package:firebase_admob/firebase_admob.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {

 /* BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  BannerAd _bannerAd;
  NativeAd _nativeAd;
  int _coins = 0;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    //_interstitialAd?.dispose();
    super.dispose();
  }*/

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
