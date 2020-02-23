import 'package:flutter/material.dart';

class PatientReminders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue[50]],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: SingleChildScrollView(
          child: Text("Reminder Screen"),
        ),
      ),
    );
  }
}
