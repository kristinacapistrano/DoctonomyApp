import 'package:flutter/material.dart';

import '../../models/state.dart';
import '../../util/state_widget.dart';

class PatientProfile extends StatefulWidget {
  static const String id = 'patient_profile';

  @override
  _PatientProfileState createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  StateModel appState;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    final signOutButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          StateWidget.of(context).logOutUser();
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColor,
        child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
      ),
    );

    final userId = appState?.firebaseUserAuth?.uid ?? '';
    final email = appState?.firebaseUserAuth?.email ?? '';
    final userIdLabel = Text('User Id: ');
    final emailLabel = Text('Email: ');
    final nameLabel = Text('Name: ');

    final fname = appState?.user?.firstName ?? "";
    final lname = appState?.user?.lastName ?? "";

    return Scaffold(
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
                  Image(
                    image: new AssetImage("assets/resizedLOGO.jpg"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.none,
                    color: Colors.red,
                    colorBlendMode: BlendMode.dst,
                  ),
                  SizedBox(height: 25.0),
                  nameLabel,
                  Text(fname + " " + lname,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  userIdLabel,
                  Text(userId, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  emailLabel,
                  Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  signOutButton
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
