import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';
import 'dart:math';

class PatientViewer extends StatefulWidget {
  static const String id = 'patient_viewer';
  final String userId;
  final String title;
  PatientViewer({Key key, @required this.userId, @required this.title}) : super(key: key);

  @override
  _PatientViewerState createState() => _PatientViewerState(userId, title);
}

class _PatientViewerState extends State<PatientViewer> {
  StateModel appState;
  List<User> userList;
  String userId;
  String title;
  _PatientViewerState(this.userId, this.title);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
        appBar: AppBar(
            textTheme: TextTheme(
                title: TextStyle(
              color: Colors.lightBlueAccent[700],
              fontSize: min(15, 500 / userId.length),
              fontWeight: FontWeight.bold,
            )),
            title: Text(title),
            iconTheme: IconThemeData(
              color: Colors.lightBlueAccent[700],
            ),
            backgroundColor: Colors.white),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue[50]],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 48.0),
                    Text("You are viewing the account of:"),
                    SizedBox(height: 12.0),
                    Text(userId, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
