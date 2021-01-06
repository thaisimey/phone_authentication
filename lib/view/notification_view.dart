import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("Device token $deviceToken");
    });
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }


 void notification() {
   _firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) async {
       print("onMessage: $message");
     },
     onLaunch: (Map<String, dynamic> message) async {
       print("onLaunch: $message");
     },
     onResume: (Map<String, dynamic> message) async {
       print("onResume: $message");
     },
   );
 }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getToken();
    // notification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text("Notification"),
        ),
      ),
    );
  }
}
