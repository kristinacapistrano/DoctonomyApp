import 'package:flutter/material.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProcedure extends StatefulWidget{
  static const String id = 'create_procedure';

  _CreateProcedureState createState() => _CreateProcedureState();
}

class _CreateProcedureState extends State{
  StateModel appState;
  final db = Firestore.instance;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form( 
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Procedure Name', 
                    ),
                ),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(onPressed: () async {
                    var procedure = { "name":_nameController.text, "description": _descController.text };
                    db.collection("procedures").add(procedure);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    return;
                    },
                    child: Text('Submit')
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}