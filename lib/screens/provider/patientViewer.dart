import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';
import 'package:cloud_functions/cloud_functions.dart';


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
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
            title: FittedBox(fit:BoxFit.fitWidth,
                child: Text(title)
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
        body:
          ListView(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(' Upcoming Procedures'),
              Card(child: ListTile(
                leading: Icon(Icons.healing),
                title: Text('Surgery'),
                subtitle: Text('Coming up on 2/20/20'),
                onTap: () {
                  print("clicked Row");
                },
              )
              ),
              Card(child: ListTile(
                leading: Icon(Icons.healing),
                title: Text('Procedure #2'),
                subtitle: Text('Coming up on 5/05/20'),
                onTap: () {
                  print("clicked Row");
                },
              )
              ),
              SizedBox(height: 20.0),
              Text(' Reminders'),
              Card(child: ListTile(
                leading: Icon(Icons.alarm),
                title: Text('Take medication'),
                subtitle: Text('Every day at 5pm'),
                onTap: () {
                  print("clicked Row");
                  CloudFunctions.instance.getHttpsCallable(
                      functionName: "patientReminder",
                  );
                  print ("reminding every 5pm");
                },
              )
              ),
              SizedBox(height: 20.0),
              Text(' Actions'),
              Card(child: ListTile(
                trailing: Icon(Icons.send),
                title: Text('Send a message'),
                onTap: () {
                  print("clicked Row");
                },
              )
              ),
              Card(child: ListTile(
                trailing: Icon(Icons.healing),
                title: Text('Schedule new procedure'),
                onTap: () {
                  print("clicked Row");
                },
              )
              ),
              Card(child: ListTile(
                trailing: Icon(Icons.clear),
                title: Text('Remove from my list'),
                onTap: () {
                  print("clicked Row");
                },
              )
              ),
            ],
          )
    );
  }
}
