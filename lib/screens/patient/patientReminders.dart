import 'package:doctonomy_app/models/state.dart';
import 'package:doctonomy_app/util/state_widget.dart';
import 'package:flutter/material.dart';

class PatientReminders extends StatelessWidget {
  StateModel appState;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.lightBlueAccent[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          title: Text("Reminders"),
          backgroundColor: Colors.white),
      body: Container(),
    );
  }
}
