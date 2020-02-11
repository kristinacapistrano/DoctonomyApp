import 'package:flutter/material.dart';

import '../../models/state.dart';
import '../../util/state_widget.dart';

class AdminProcedures extends StatefulWidget {
  static const String id = 'admin_home';

  _AdminProceduresState createState() => _AdminProceduresState();
}

class _AdminProceduresState extends State<AdminProcedures> {
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
          title: Text("Procedures"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.blue,
              onPressed: () {
                print('Add procedure');
              },
            ),
          ],
          backgroundColor: Colors.white
          ),
      body: ListView(
        children: <Widget>[
          Card(child: ListTile(
              leading: Icon(Icons.chevron_right),
              title: Text('Procedure #1'),
              subtitle: Text('Short description for procedure #1'),
              onTap: () {
                print("clicked Row");
              },
            )
          ),
          Card(child: ListTile(
            leading: Icon(Icons.chevron_right),
            title: Text('Procedure #2'),
            subtitle: Text('Short description for procedure #2'),
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
