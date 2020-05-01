import 'package:craftbeer/abstractions/brewer_model.dart';
import 'package:craftbeer/api_service.dart';
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
  final Brewer brewer;
  final int brewerID;

  BrewersDetail({this.brewer, this.brewerID});

  final DataBaseService db = DataBaseService();

  @override
  Widget build(BuildContext context) {
    var brewers = Provider.of<BrewersData>(context).brewers;

    if (brewer == null && brewerID != null) {
      return FutureBuilder(
          future: db.futureBrewerByID(brewers, brewerID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BrewerViewBody(snapshot.data);
            } else {
              return Scaffold(
                body: LoadingWidget(),
              );
            }
          });
    } else if (brewer != null) {
      return BrewerViewBody(brewer);
    }
  }
}

class BrewerViewBody extends StatefulWidget {
  final Brewer brewer;

  BrewerViewBody(this.brewer);

  @override
  _BrewerViewBodyState createState() => _BrewerViewBodyState(brewer);
}

class _BrewerViewBodyState extends State<BrewerViewBody> {
  final Brewer brewer;
  _BrewerViewBodyState(this.brewer);

  final DataBaseService db = DataBaseService();

  @override
  void dispose() {
    super.dispose();
  }

  void openWhatsApp() async {
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
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Stack(
          children: <Widget>[
            BrewerHeader(brewer),
            BrewerContent(brewer: brewer),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[600],
        child: brewer.canSale ? Icon(BeerIcon.car) : Icon(BeerIcon.user_filled),
        onPressed: () => openWhatsApp(),
      ),
    );
  }
}
