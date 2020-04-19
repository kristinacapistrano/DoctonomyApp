import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';

//use of FIREBASE MESSAGE - not implemented to be used within the app,
//need firebase console to send app - this code is to connect the console
//notification to app, so app can receive console's notification.

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidget createState() => _NotificationWidget();
}

class _NotificationWidget extends State<NotificationWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(

      //user is using the app when the message is received
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      //executes when app is closed
      onLaunch: (Map<String, dynamic> message) async {
        print("launching: $message");

        final notification = message['this is data coming from code note firebase'];
        setState(() {
          messages.add(Message(
            title: '${notification['title on code ']}',
            body: '${notification['body on code ']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("on Resume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => ListView(
    children: messages.map(buildMessage).toList(),
  );

  Widget buildMessage(Message message) => ListTile(
    title: Text(message.title),
    subtitle: Text(message.body),
  );
}