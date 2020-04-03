import 'package:craftbeer/bloc_provider.dart';
import 'package:craftbeer/repository/api.dart';

class EventsBloc implements BlocBase {
  Stream fetchEvents() => db.fetchEvents();
  Stream fetchPromotions() => db.fetchPromotions();

  @override
  void dispose() {}
}
