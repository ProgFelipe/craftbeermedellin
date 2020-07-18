import 'dart:async';

import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/providers/delivery_picker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Consents extends StatefulWidget {
  @override
  _ConsentsState createState() => _ConsentsState();
}

class _ConsentsState extends State<Consents> {
  static final consentsUri = "https://www.craftbeercolombia.co/consents";
  static final consentsWithOutInvimaUri =
      "https://www.craftbeercolombia.co/consentsinvimarest";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool showProgress = true;

  @override
  initState() {
    super.initState();
    showProgress = true;
  }

  void openWhatsApp(Brewer brewer, String deliveryUri, context) async {
    String message =
        "${brewer.name}\n${S.of(context).i_would_like_to_to_buy_msg}";
    String url =
        "whatsapp://send?phone=${brewer.phone}&text=$message\n\nDirección Envío:\n\n${deliveryUri}";
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        globalKey.currentState.showSnackBar(SnackBar(
          content: Text(S.of(context).whatsapp_error),
        ));
      }
    } catch (e) {
      globalKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).whatsapp_error),
      ));
    }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryPickerData>(
        builder: (context, deliveryData, child) {
      return Consumer<BrewersData>(builder: (context, brewerData, child) {
        return Scaffold(
          key: globalKey,
          backgroundColor: Colors.black54,
          body: SafeArea(
            child: Builder(builder: (BuildContext context) {
              return Stack(
                children: [
                  Container(
                    child: WebView(
                      initialUrl: brewerData.currentBrewer.canSale
                          ? consentsUri
                          : consentsWithOutInvimaUri,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await deliveryData.preFillDataIfExist();
              openWhatsApp(
                  brewerData.currentBrewer,
                  "${deliveryData.delivery.address}\n${deliveryData.delivery.description}\n\n" +
                      deliveryData.getDeliveryMapsUri(),
                  context);
            },
            child: Text(
              'Acepto',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      });
    });
  }
}
