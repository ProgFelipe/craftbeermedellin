import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier{
  bool loadingState = false;

  void showLoading(){
    loadingState = true;
    notifyListeners();
  }

  void hideLoading(){
    loadingState = false;
    notifyListeners();
  }
}