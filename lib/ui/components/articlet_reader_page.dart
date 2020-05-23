import 'dart:async';

import 'package:craftbeer/abstractions/article_model.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleReader extends StatefulWidget {
  final Article article;

  ArticleReader({@required this.article});

  @override
  _ArticleReaderState createState() => _ArticleReaderState();
}

class _ArticleReaderState extends State<ArticleReader> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool showProgress = true;

  @override
  initState(){
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: WebView(
                  initialUrl: widget.article.contentUri,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                  // ignore: prefer_collection_literals
                  javascriptChannels: <JavascriptChannel>[
                    _toasterJavascriptChannel(context),
                  ].toSet(),
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
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
    );
  }
}
