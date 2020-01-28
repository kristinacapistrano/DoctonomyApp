import 'package:flutter/material.dart';

import '../../models/state.dart';
import '../../util/state_widget.dart';

class PatientChooser extends StatefulWidget {
  static const String id = 'patient_chooser';

  _PatientChooserState createState() => _PatientChooserState();
}

class _PatientChooserState extends State<PatientChooser> {
  StateModel appState;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
      appBar: AppBar(
          textTheme: TextTheme(
              title: TextStyle(
                color: Colors.lightBlueAccent[700],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          title: Text("Select a Patient"),
          iconTheme: IconThemeData(
            color: Colors.lightBlueAccent[700],
          ),
          backgroundColor: Colors.white
          ),
      body: ListView(
        children: <Widget>[
          Card(child: ListTile(
              leading: Icon(Icons.face),
              title: Text('John Doe'),
//              subtitle: Text('subtitle text.'),
              onTap: () {
                print("clicked Row");
              },
            )
          ),
          Card(child: ListTile(
            leading: Icon(Icons.face),
            title: Text('Bob Smith'),
//              subtitle: Text('subtitle text.'),
            onTap: () {
              print("clicked Row");
            },
          )
          ),
        ],
      ),
    );
  }
}
