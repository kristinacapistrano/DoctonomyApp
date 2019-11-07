
import 'package:doctonomy_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class MessagingWidget extends StatefulWidget{
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages =[]; //will contain messages from the FB console


  void initState() {
    super.initState();
    _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          final notification = message['notification'];
          setState(() {
            messages.add(Message(
                title: notification['title'], body: notification['body']
            ));
          });
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        }
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

  }

  @override
  Widget build(BuildContext) => ListView(
    children: messages.map(buildMessage).toList(),
  );

  Widget buildMessage(Message message) => ListTile(
      title: Text(message.title),
      subtitle: Text(message.body)
  );
}

