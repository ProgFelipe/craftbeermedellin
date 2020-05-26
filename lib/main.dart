import 'package:connectivity/connectivity.dart';
import 'package:craftbeer/abstractions/event_model.dart';
import 'package:craftbeer/abstractions/promotion_model.dart';
import 'package:craftbeer/abstractions/release_model.dart';
import 'package:craftbeer/api_service.dart';
import 'package:craftbeer/providers/articles_provider.dart';
import 'package:craftbeer/providers/brewer_provider.dart';
import 'package:craftbeer/providers/categories_provider.dart';
import 'package:craftbeer/providers/map_notifier.dart';
import 'package:craftbeer/providers/push_notifications_provider.dart';
import 'package:craftbeer/ui/components/beer_icon_icons.dart';
import 'package:craftbeer/ui/events/events_view.dart';
import 'package:craftbeer/ui/explore/explore_view.dart';
import 'package:craftbeer/ui/home/home_view.dart';
import 'package:craftbeer/ui/map/map_view.dart';
import 'package:craftbeer/ui/user/user_area_view.dart';
import 'package:craftbeer/ui/utils/custom_colors.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'generated/l10n.dart';

void main() {
  // Pass all uncaught errors from the framework to Crashlytics.
  if(kReleaseMode) {
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final database = Api();
  final connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityResult>.value(
            value: connectivity.onConnectivityChanged),

        ///Django
        ChangeNotifierProvider<BrewersData>.value(value: BrewersData()),
        ChangeNotifierProvider<CategoriesData>.value(value: CategoriesData()),
        ChangeNotifierProvider<ArticlesData>.value(value: ArticlesData()),
        ChangeNotifierProvider<MapNotifier>.value(value: MapNotifier()),

        ///FireStore
        StreamProvider<List<Release>>.value(value: database.fetchReleases()),
        StreamProvider<List<Promotion>>.value(
            value: database.streamPromotions()),
        StreamProvider<List<Event>>.value(value: database.streamEvents()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Craft Beer Co',
        supportedLocales: S.delegate.supportedLocales,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
            primarySwatch: Colors.orange,
            primaryColor: kBlackLightColor,
            cursorColor: Colors.orange,
            fontFamily: 'FellGreat',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            })),
        home: SplashScreen.navigate(
          name: 'assets/splash.flr',
          next: (context) => Navigator(),
          until: () => Future.delayed(Duration(seconds: 2)),
          startAnimation: 'Splash',
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class Navigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigatorState();
  }
}

class _NavigatorState extends State<Navigator> {
  int _currentIndex = 0;
  PageController _pageController;
  PushNotificationsProvider _pushProvider;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> screens = [
    Home(),
    ExploreView(),
    UserAreaView(),
    EventsView(),
    CraftMap(),
  ];

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _pushProvider.dispose();
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _currentIndex,
    );

    _pushProvider = PushNotificationsProvider();
    _pushProvider.initNotifications();
    _pushProvider.messages.listen((event) {
      debugPrint('EVENTO');
      debugPrint(event);
      if (event == 'nav_event') {
        _pageController.animateToPage(2,
            duration: Duration(seconds: 2), curve: Curves.bounceOut);
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(event),
          duration: Duration(seconds: 3),
        ));
      }
    });

    super.initState();
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: S.of(context).warning_exit);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          physics: _currentIndex == 4
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (newPage) {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              this._currentIndex = newPage;
            });
          },
          children: screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.grey,
        backgroundColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        iconSize: 25.0,
        onTap: (index) {
          this._pageController.animateToPage(index,
              duration: Duration(microseconds: 500), curve: Curves.easeInOut);
        },
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              BeerIcon.home_empty,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              BeerIcon.home_filled,
              color: Colors.white,
            ),
            title: Text(S.of(context).home_nav_title),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            title: Text(S.of(context).home_nav_title),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BeerIcon.beer_empty,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              BeerIcon.beer_filled,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            title: Text(S.of(context).beer_nav_title),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BeerIcon.ticket_empty,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              BeerIcon.ticket_filled,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
            title: Text(S.of(context).events_nav_title),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              BeerIcon.map_empty,
              color: Colors.grey,
            ),
            activeIcon: Icon(
              BeerIcon.map_empty,
              color: Colors.white,
            ),
            title: Text(''),
          ),
        ],
      ),
    );
  }
}
