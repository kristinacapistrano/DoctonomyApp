import 'package:flutter/material.dart';
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
      body: Form( 
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Procedure Name',
                ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Description',
                ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(onPressed: (){
                print('form submitted');
                },
                child: Text('Submit')
              ),
            )
          ],
        ),
      ),
    );
  }
}