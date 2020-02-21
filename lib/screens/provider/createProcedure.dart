import 'package:doctonomy_app/screens/provider/adminProcedures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/semantics.dart';
import '../../models/surgery.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';

class CreateProcedure extends StatefulWidget{
  static const String id = 'create_procedure';

  _CreateProcedureState createState() => _CreateProcedureState();
}

class _CreateProcedureState extends State{
  StateModel appState;

  @override
  void initState() {
    super.initState();
  }

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
          )
        ),
        title: Text("Create a new procedure"),
        iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
        backgroundColor: Colors.white,
        
    ),
    );
  }
}