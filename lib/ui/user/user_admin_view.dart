import 'package:craftbeer/connectivity_widget.dart';
import 'package:craftbeer/generated/l10n.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:craftbeer/utils.dart';
import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConnectivityWidget(),
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  'assets/icon.png',
                  height: 120.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                    height: 50.0,
                    width: double.infinity,
                    child: FlatButton.icon(
                      onPressed: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'ESTAMOS TRABAJANDO EN ELLO TÍO...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      },
                      icon: Icon(
                        BeerIcon.google,
                        color: Colors.green[200],
                      ),
                      label: Text(
                        S.of(context).login,
                        style:
                            TextStyle(fontSize: 20.0, color: Colors.green[200]),
                      ),
                      color: Colors.green,
                    )),
                SizedBox(
                  height: 20.0,
                ),
                titleView(S.of(context).login_benefits_title,
                    color: zelyonyGreenLightColor),
                ListTile(
                  leading: MyBullet(),
                  title: Text(
                    S.of(context).login_benefits_one,
                    style: TextStyle(color: zhenZhuBaiPearl),
                  ),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text(
                    S.of(context).login_benefits_two,
                    style: TextStyle(color: zhenZhuBaiPearl),
                  ),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text(
                    S.of(context).login_benefits_three,
                    style: TextStyle(color: zhenZhuBaiPearl),
                  ),
                ),
                ListTile(
                  leading: MyBullet(),
                  title: Text(
                    S.of(context).login_benefits_fourth,
                    style: TextStyle(color: zhenZhuBaiPearl),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.0,
      decoration: BoxDecoration(
        color: Colors.white70,
        shape: BoxShape.circle,
      ),
    );
  }
}
