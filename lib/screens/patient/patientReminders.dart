import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctonomy_app/models/state.dart';
import 'package:doctonomy_app/util/state_widget.dart';
import 'package:flutter/material.dart';

class PatientReminders extends StatelessWidget {
  StateModel appState;

  Future<List<dynamic>> getList() async {
    DocumentReference docRef = Firestore.instance
        .collection('reminders')
        .document(appState?.firebaseUserAuth?.uid ?? "");

    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        List<String> list = new List();

        for (final v in datasnapshot.data.values) {
          list.add(v);
        }

        return list;
      } else {
        return [];
      }
    });
  }

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
