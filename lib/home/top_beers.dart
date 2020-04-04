import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craftbeer/brewers/brewers_detail.dart';
import 'package:craftbeer/components/beer_detail_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> beerFavorites = [
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol',
  'IPA\nGuardian',
  'PORTER\n20 Mission',
  'SOUT\nApostol'
];

class TopBeersView extends StatelessWidget {
  final List<DocumentSnapshot> elements;
  TopBeersView({this.elements});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: beerFavorites.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => BeerDetailDialog(
                        title: 'Cerveza Platinium',
                        description:
                            'Cerveza creada en las montañas de Colombia',
                        avatarImage:
                            'https://images.rappi.com/products/2091421499-1579543158965.png?d=200x200',
                        buttonText: "Volver",
                        starts: true,
                        actionText: "Contactanos",
                        action: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BrewersDetail('XqHetWY4yy3BmRdDsS4C')));
                        },
                      ));
            },
            child: Card(
              elevation: 20.0,
              child: Stack(
                fit: StackFit.passthrough,
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Image.asset(
                    'assets/beer.png',
                    height: 60.0,
                  ),
                  Text(
                    beerFavorites[index],
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
