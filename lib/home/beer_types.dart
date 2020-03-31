import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BeerTypes extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return _buildTypesOfLicors();
  }

  Widget _buildTypesOfLicors(){
    return  Container(
      height: 200.0,
            child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 0.0),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              var child = _buildBeerTypeItem('IPA', 'https://freeiconshop.com/wp-content/uploads/edd/beer-bottle-flat.png');
              return GestureDetector(
                  child: child,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => null)));
            }),
    );}

Widget _buildCarousel(String title, String imageUri) {
  return  SizedBox(
    // you may want to use an aspect ratio here for tablet support
    height: 200.0,
    child: PageView.builder(
      // store this controller in a State to save the carousel scroll position
      controller: PageController(viewportFraction: 0.8),
      itemBuilder: (BuildContext context, int itemIndex) {
        return _buildBeerTypeItem(title, imageUri);
      },
    ),
  );
}


  Widget _buildBeerTypeItem(String title, String uriImage) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child:  Container(
      height: 200.0,
        child:  Card(
          child:  Image(
            image: CachedNetworkImageProvider(uriImage),
          ),
          elevation: 4.0,
        ),
        decoration:  BoxDecoration(boxShadow: [
           BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
          ),
        ])),
  );}
}