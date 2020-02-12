import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

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

  Future<List<dynamic>> getList() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(userId ?? "");
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data['allergies'].toList();
        /*List<dynamic> info = datasnapshot.data['patients'].toList();
        List<dynamic> list = new List();
        for(var uid in info) {
          DocumentReference dr = Firestore.instance.collection('users').document(uid);
          DocumentSnapshot ds = await dr.get();
          list.add(ds);
        }
        return list;*/
      } else {
        return [];
      }
    });
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
                },
              )
              ),
              SizedBox(height: 20.0),
              Text(' Allergies'),

              FutureBuilder(
                future: getList(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Card(child: CircularProgressIndicator());
                  } else {
                    // TODO Improve showing as a list
                    print(snapshot.data);
                    if (snapshot.data.length > 0) {
                      return Card(child: ListTile(
                        title: Text(snapshot.data[0]),
                        onTap: () {
                          print("clicked Row");
                        },
                      )
                      );
                    } else {
                      return Card(child: ListTile(
                        title: Text("No Allergies"),
                        onTap: () {
                          print("clicked Row");
                        },
                      )
                      );
                    }

                  }
              }),

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
