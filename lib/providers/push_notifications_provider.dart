import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messagesStreamController = StreamController<String>.broadcast();
  Stream<String> get messages => _messagesStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token){
      print('===== FCM TOKEN =====');
      print(token);

      //dMPUEZG3Stm0n36m_iwB90:APA91bEHyQDYi8I0_0gBYQGkvAwCE_J3RN1TOHcqY4kLCBo3AqPEATQ9wVdLN2GkdMGVc7yQeJWUD8oT8MbwLaWck34UUY5S62lvksmel8ZOYEwm3mX1gbl5fRraVTF0vrE84WDOiC_6
    });

    _firebaseMessaging.configure(
      onMessage: (info){
        print('===== On Message =====');
        print(info);


        return;
      },
      onLaunch: (info){
        print('===== On Launch =====');
        print(info);
        print(info['data']);
        getNotification(info);
        return;
      },
      onResume: (info){
        print('===== On Resume =====');
        print(info);
        getNotification(info);
        return;
      }
    );
  }

  void getNotification(info){
    var snackData = info['data']['new_beer'];
    if(snackData != null){
      _messagesStreamController.sink.add(snackData);
    }else if(info['data']['new_event'] != null){
      _messagesStreamController.sink.add(info['data']['new_event']);
    }
    var navigateTo = info['data']['navigate_to'];
    if(navigateTo != null){
      _messagesStreamController.sink.add(navigateTo);
    }
  }

  dispose(){
    _messagesStreamController?.close();
  }


}