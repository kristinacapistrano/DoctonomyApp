import 'package:flutter/material.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/AlertTextbox.dart';



class PatientHome extends StatefulWidget {
  static const String id = 'patient_home';

  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  StateModel appState;
  String title = "";
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String,dynamic>> getUserData() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid);
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data;
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.lightBlueAccent[700],
                  fontWeight: FontWeight.bold,
                )
            ),
            centerTitle: true,
            title: FittedBox(fit:BoxFit.fitWidth,
                child: Text("My Info")
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
        body:
        Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: FutureBuilder(
                future: getUserData(),
                builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    print(snapshot.data);
                    return Center(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text('Upcoming Procedures', style: TextStyle(fontWeight: FontWeight.w500)),
                          //TODO remove hardcoded card
                          Card(child: ListTile(
                            leading: Icon(Icons.healing),
                            title: Text('Surgery'),
                            subtitle: Text('Coming up on 2/20/20'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),

                          SizedBox(height: 20.0),
                          Text('Reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                          //TODO remove hardcoded card
                          Card(child: ListTile(
                            leading: Icon(Icons.alarm),
                            title: Text('Take medication'),
                            subtitle: Text('Every day at 5pm'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),

                          //Allergy information
                          SizedBox(height: 20.0),
                          Text('Allergies', style: TextStyle(fontWeight: FontWeight.w500)),
                          Card(child: ListTile(
                            title: Text('Allergy placeholder'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          )
                        ],
                      ),
                    );
                  }
                }
            )

        )
    );
  }

}
