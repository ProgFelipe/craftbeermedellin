import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class PushNotificationsProvider{

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _messagesStreamController = StreamController<String>.broadcast();
  Stream<String> get messages => _messagesStreamController.stream;

  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((token){
      debugPrint('===== FCM TOKEN =====');
      debugPrint(token);

      //dMPUEZG3Stm0n36m_iwB90:APA91bEHyQDYi8I0_0gBYQGkvAwCE_J3RN1TOHcqY4kLCBo3AqPEATQ9wVdLN2GkdMGVc7yQeJWUD8oT8MbwLaWck34UUY5S62lvksmel8ZOYEwm3mX1gbl5fRraVTF0vrE84WDOiC_6
    });

    _firebaseMessaging.configure(
      onMessage: (info){
        debugPrint('===== On Message =====');
        print(info);


        return;
      },
      onLaunch: (info){
        debugPrint('===== On Launch =====');
        debugPrint("$info");
        debugPrint(info['data']);
        getNotification(info);
        return;
      },
      onResume: (info){
        debugPrint('===== On Resume =====');
        debugPrint("$info");
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