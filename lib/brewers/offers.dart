import 'package:craftbeer/components/decoration_constants.dart';
import 'package:flutter/material.dart';

class Offers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String package1 = 'https://dtgxwmigmg3gc.cloudfront.net/imagery/assets/derivations/icon/256/256/true/eyJpZCI6Ijk4YzBkODg3ZTkxYjMwMzc5MzdkMWFmNzNlM2MwYzdhIiwic3RvcmFnZSI6InB1YmxpY19zdG9yZSJ9?signature=0b78c6c23414167e18b4e114d938c140977f07f33fc4bef26ece458df3f6d763';
    String package3 = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRJxP0lBq12_AqStLikQ2nhT0cUJhticsUvm9TmKY5oSg82gDKt&usqp=CAU';
    String package2 = 'https://dtgxwmigmg3gc.cloudfront.net/imagery/assets/derivations/icon/256/256/true/eyJpZCI6ImQ3YTk4OWNhOWQwMGI0NDQ1MTYwZTE0N2Y5MjE0NTdjIiwic3RvcmFnZSI6InB1YmxpY19zdG9yZSJ9?signature=b9622ac7111ab127a86f8437d815855d640c1f760ce61b80d51eceb1478f65fb';
    List<String> offers = [package1, package2,package3];
    List<String> description = ['10% menos por el mes\de abril', '2x1 mes de abril', '330 ml a \$60.000'];
    List<String> left = ['solo quedan 2', 'solo quedan 30', 'hasta agotar existencia'];


    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 200.0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: offers.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              shape: cardDecoration(),
              elevation: 3.0,
              color: Colors.white,
              semanticContainer: true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.network(offers[index],
                        width: 100.0, fit: BoxFit.cover),
                    Text(description[index]),
                    Text(left[index]),
                  ],
                ),
              ));
        },
      ),
    );
  }
}