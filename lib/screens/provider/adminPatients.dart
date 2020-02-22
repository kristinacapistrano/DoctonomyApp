import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import './patientChooser.dart';
import './patientViewer.dart';

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

    // TODO: add a way to remove patients from the list
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        List<dynamic> info = datasnapshot.data['patients'].toList();
        List<dynamic> list = new List();
        for(var uid in info) {
          DocumentReference dr = Firestore.instance.collection('users').document(uid);
          DocumentSnapshot ds = await dr.get();
          list.add(ds);
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
            brightness: Brightness.light,
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
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final dynamic document = snapshot.data[index];
                        var name = "(No Name) " + document.documentID;
                        if (document.data != null) {
                          var fName = document.data["firstName"] ?? "";
                          var lName = document.data["lastName"] ?? "";
                          name = fName + " " + lName;
                        }
                        if (name == " ") {
                          name = "(No Name) " + document.documentID;
                        }
                        return new Card(
                            child: ListTile(
                              leading: Icon(Icons.face),
                              title: Text(name),
                              onTap: () {
                                print("Clicked Patient: " + document.documentID);
                                Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (BuildContext context) {
                                      return new PatientViewer(userId: document.documentID, title: name);
                                    },
                                        fullscreenDialog: true
                                    )
                                );
                              }
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


