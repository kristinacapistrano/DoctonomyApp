import 'package:flutter/material.dart';

import '../../models/state.dart';
import '../../util/state_widget.dart';

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
//    final signOutButton = Padding(
//      padding: EdgeInsets.symmetric(vertical: 16.0),
//      child: RaisedButton(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(24),
//        ),
//        onPressed: () {
//          StateWidget.of(context).logOutUser();
//        },
//        padding: EdgeInsets.all(12),
//        color: Theme.of(context).primaryColor,
//        child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
//      ),
//    );

//    final userId = appState?.firebaseUserAuth?.uid ?? '';
//    final email = appState?.firebaseUserAuth?.email ?? '';
//
//    final userIdLabel = Text('User Id: ');
//    final emailLabel = Text('Email: ');

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
