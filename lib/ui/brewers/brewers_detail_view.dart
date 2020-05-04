import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/loading_widget.dart';
import 'package:craftbeer/models/brewer_data_notifier.dart';
import 'package:craftbeer/ui/brewers/brewer_content.dart';
import 'package:craftbeer/ui/brewers/brewer_header.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//Parallax effect
//https://github.com/MarcinusX/buy_ticket_design/blob/master/lib/exhibition_bottom_sheet.dart
class BrewersDetail extends StatelessWidget {
  final int brewerId;

  BrewersDetail({this.brewerId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(
      builder: (context, brewerData, child) {
        return FutureBuilder(
          future: brewerData.getBrewerById(brewerId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BrewerViewBody();
            } else {
              return Scaffold(
                body: LoadingWidget(),
              );
            }
          },
        );
      },
    );
  }
}

class BrewerViewBody extends StatelessWidget {
  void openWhatsApp(Brewer brewer, context) async {
    String message =
        "${brewer.name}\n${S.of(context).i_would_like_to_to_buy_msg}";

    String url = 'whatsapp://send?phone=${brewer.phone}&text=$message';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).whatsapp_error),
        ));
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(S.of(context).whatsapp_error),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BrewersData>(
      builder: (context, brewerData, child) {
        return Scaffold(
          body: Container(
            color: Colors.black87,
            child: Stack(
              children: <Widget>[
                BrewerHeader(brewerData.currentBrewer),
                BrewerContent(brewerData.currentBrewer),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green[600],
            child: brewerData.currentBrewer.canSale
                ? Icon(BeerIcon.car)
                : Icon(BeerIcon.user_filled),
            onPressed: () => openWhatsApp(brewerData.currentBrewer, context),
          ),
        );
      },
    );
  }
}
