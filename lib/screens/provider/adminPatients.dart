import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<dynamic>> getList() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(
        appState?.firebaseUserAuth?.uid ?? "");

    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['patients'].toList();
        List<dynamic> list = new List();
        for(var uid in info) {
          DocumentReference dr = Firestore.instance.collection('users').document(uid);
          DocumentSnapshot ds = await dr.get();
          if (ds.exists) {
            list.add(ds.data);
          }
        }
        return list;
      } else {
        return [];
      }
    });
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
                )
            ),
            title: Text("Patients"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.blue,
                onPressed: () {
                  print('Add patient');
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
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
        body: FutureBuilder(
            future: getList(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Center(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return new Card(
                            child: ListTile(
                              leading: Icon(Icons.face),
                              title: Text(snapshot.data[0]["firstName"]),
                            )
                        );
                      }),
                );
              }
            }
        )
    );
  }
}


