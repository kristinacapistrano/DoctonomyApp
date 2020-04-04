import 'package:flutter/material.dart';

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body, //the message we get from the firebase
  });
}