import 'dart:async';
import 'package:craftbeer/bloc_provider.dart';
import 'package:craftbeer/repository/api.dart';

class HomeBloc implements BlocBase {
  HomeBloc() {
    //initiate stream
  }

  Stream fetchBrewers() => db.fetchBrewers();

  //final _controller = StreamController<List<Brewer>>();
  //Stream<<List<Brewer>> get brewers => _controller.stream;

  @override
  void dispose() {
    //_controller.close();
  }
}
