import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialItem extends StatelessWidget {
  final bool visible;
  final String uri;
  final IconData icon;

  SocialItem({@required this.visible, @required this.uri, @required this.icon});

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: FlatButton(
          onPressed: () {
            _launchInBrowser(uri);
          },
          child: Icon(
            icon,
            size: 40.0,
          )),
    );
  }
}
