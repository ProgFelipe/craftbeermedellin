import 'dart:math';

import 'package:craftbeer/ui/components/decoration_constants.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ArticlesWidget extends StatefulWidget {
  @override
  _ArticlesWidgetState createState() => _ArticlesWidgetState();
}

class RandomColor {
  final colors = [
    kCitrusEndCustomColor,
    kCitrusStartCustomColor,
    kMoonlitAsteroidStartColor,
    kMoonlitAsteroidEndColor,
    kZiSePurpleColor,
    kZelyonyGreenColor
  ];

  final random = Random();

  Color getRandomColor() {
    return colors[random.nextInt(colors.length - 1)];
  }
}

class _ArticlesWidgetState extends State<ArticlesWidget> {
  final RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ArticleReader(index);
                },
              ));
            },
            child: Card(
                shape: cardDecoration(),
                elevation: 3.0,
                color: _randomColor.getRandomColor(),
                semanticContainer: true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Articulo nombre $index',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          );
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      ),
    );
  }
}

class ArticleReader extends StatefulWidget {
  final index;

  ArticleReader(this.index);

  @override
  _ArticleReaderState createState() => _ArticleReaderState(index);
}

class _ArticleReaderState extends State<ArticleReader> {
  final index;

  _ArticleReaderState(this.index);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.85),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  titleView('El color de las cervezas'),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce tempus placerat venenatis. Praesent tincidunt ut erat vel sollicitudin. Donec nec orci placerat, vulputate enim ut, volutpat diam. Vestibulum sagittis lobortis porta. Ut varius metus nec ante aliquet, id lacinia risus tincidunt. Etiam tincidunt placerat imperdiet. Mauris lacinia eros eu lorem euismod laoreet. Nulla consectetur purus a sem vehicula, quis ullamcorper purus pharetra. Nam fermentum et velit sed molestie. Nam sagittis pharetra ex, a egestas neque varius vel. Fusce ultricies justo et leo tempor posuere. Nunc porttitor nibh sagittis ex imperdiet, quis feugiat ligula ornare. Nam molestie leo ut viverra auctor. Nullam interdum et nunc vel suscipit. Ut placerat orci vel dui finibus interdum. Nunc feugiat augue sed erat finibus, non luctus justo vestibulum.'
                    'Praesent ac mattis ligula. Suspendisse tristique pharetra purus, eu vehicula massa varius in. Donec leo nibh, scelerisque vel enim ut, efficitur auctor nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Cras a ex suscipit, pharetra nulla in, varius nisl. Donec venenatis eros ac venenatis euismod. In ex magna, blandit vel mi at, suscipit congue enim. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer sit amet lacus eu est ultricies mollis.'
                    'Praesent convallis tortor malesuada nisi sagittis tempus. Suspendisse potenti. In efficitur, mi quis tristique tristique, ipsum ex congue sapien, quis porta nisi sapien non risus. Sed metus mauris, sollicitudin ac sodales quis, sagittis nec velit. Nulla dignissim metus ac ex fermentum, vel auctor arcu semper. Donec orci risus, blandit eu eleifend sit amet, scelerisque sed metus. Suspendisse potenti. Ut auctor a elit vel porta. In in arcu nulla. Morbi elementum mauris vel nibh lacinia, nec ultrices dolor lacinia. Vestibulum diam eros, feugiat et tempor ac, vehicula sed libero. Mauris magna nisi, suscipit et scelerisque id, cursus rutrum ante. Nullam eu lectus gravida, ultrices diam id, consequat lorem.'
                    'Donec porta non metus non volutpat. Curabitur id vehicula urna. Nulla feugiat id ligula ac maximus. Nulla malesuada auctor semper. Suspendisse dapibus ullamcorper dignissim. Integer ultrices egestas est, sit amet feugiat nulla rhoncus ac. Aenean diam lacus, lacinia id mauris et, tempor tristique dui. Integer non metus volutpat sem commodo vulputate ut ut lorem. Sed id metus euismod, lobortis urna in, efficitur nisi. Pellentesque a nibh tincidunt, porta orci a, maximus magna.'
                    'Aliquam tincidunt enim vel metus elementum, non feugiat dui facilisis. Pellentesque posuere, leo dignissim fringilla facilisis, nisl justo convallis lacus, at malesuada justo urna vel nisl. Quisque sit amet orci ultricies, mollis turpis eget, dictum lacus. Curabitur et accumsan nisi. Vivamus id iaculis est. Proin faucibus dolor vitae sapien pellentesque aliquam. Fusce et dictum diam. Duis quis semper ligula, ac posuere dolor. Nunc maximus magna nec lacinia lacinia. Duis feugiat justo at mi gravida malesuada. Pellentesque nec commodo ex, at luctus purus. Nam eu sapien libero. Phasellus vehicula magna nibh, id vestibulum est fermentum eget. Fusce sed massa non tortor eleifend vehicula vel non urna.'
                    'Curabitur sed tellus nec orci interdum commodo. Morbi vitae venenatis ligula. Mauris ex dolor, elementum vitae elit nec, congue hendrerit augue. Praesent at ex condimentum diam mollis viverra sed vitae tellus. Donec id feugiat odio, non convallis risus. Nullam interdum blandit arcu eget finibus. Vivamus et quam nunc. Nam non elit laoreet, aliquet velit vel, finibus lorem.',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (index == 1) {
      return Container(
          color: Colors.white, child: Image.asset('assets/tiposcerveza.png'));
    } else {
      return Container(
          color: Colors.white, child: Image.asset('assets/colorescerveza.jpg'));
    }
  }
}
