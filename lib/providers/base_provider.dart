import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class BaseProvider extends ChangeNotifier{
  ConnectivityResult connectivityResult;

  bool loadingState = false;

  void showLoading(){
    loadingState = true;
    notifyListeners();
  }

  void hideLoading(){
    loadingState = false;
    notifyListeners();
  }

  void dispose() {
    super.dispose();
  }
}