import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier{
  bool underMaintainState = false;
  bool loadingState = false;
  bool checkYourInternet = false;
  bool errorStatus = false;

  void showLoading(){
    loadingState = true;
    notifyListeners();
  }

  void hideLoading(){
    loadingState = false;
    notifyListeners();
  }
}