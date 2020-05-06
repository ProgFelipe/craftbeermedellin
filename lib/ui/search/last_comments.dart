import 'package:flutter/material.dart';

class LastComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => CommentCard(),
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
              'Conocí la Cerveceria X me encanto esa cerveza y deseó volver a probar una nueva'),
        ),
      ),
    );
  }
}
