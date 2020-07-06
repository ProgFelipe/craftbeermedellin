import 'dart:async';

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForumView extends StatefulWidget {
  final Brewer brewer;
  const ForumView({Key key, this.brewer}) : super(key: key);

  @override
  _ForumViewState createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  //static final forumUri = "https://www.craftbeercolombia.co/foro";
  static final forumUri = "https://groups.google.com/forum/embed/?place=forum/artesana_co";

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool showProgress = true;

  @override
  initState() {
    super.initState();
    showProgress = true;
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  final globalKey = GlobalKey<ScaffoldState>();

  WebViewController controllerGlobal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: WebView(
                  initialUrl: forumUri,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) {
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    setState(() {
                      showProgress = false;
                    });
                    print('Page finished loading: $url');
                  },
                  gestureNavigationEnabled: true,
                ),
              ),
              Center(
                child: Visibility(
                  visible: showProgress,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

      }, child: Icon(Icons.assignment_ind),),
    );
  }
}
