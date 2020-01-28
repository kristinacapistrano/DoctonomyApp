import 'package:flutter/material.dart';

import '../../models/state.dart';
import '../../util/state_widget.dart';
import './patientChooser.dart';

class AdminPatients extends StatefulWidget {
  static const String id = 'admin_home';

  _AdminPatientsState createState() => _AdminPatientsState();
}

class _AdminPatientsState extends State<AdminPatients> {
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
          title: Text("Patients"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.blue,
              onPressed: () {
                print('Add patient');
                Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) {
                          return new PatientChooser();
                        },
                        fullscreenDialog: true
                    )
                );
              },
            ),
          ],
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
