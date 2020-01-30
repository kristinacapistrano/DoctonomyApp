import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

class PatientChooser extends StatefulWidget {
  static const String id = 'patient_chooser';

  _PatientChooserState createState() => _PatientChooserState();
}

class _PatientChooserState extends State<PatientChooser> {
  StateModel appState;
  List<User> userList;

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
            backgroundColor: Colors.white),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("users")
                .where("firstName", isGreaterThanOrEqualTo: "")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  var users = List<DocumentSnapshot>();
                  snapshot.data.documents.forEach((ds) {
                    if (ds.data["admin"] == null || !ds.data["admin"]) {
                      users.add(ds);
                    }
                  });
                  final int eventCount = users.length;
                  return new ListView.builder(
                      itemCount: eventCount,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document = users[index];
                        return new Card(
                            child: ListTile(
                          leading: Icon(Icons.face),
                          title: Text(document.data["firstName"] ?? "N/A"),
                        ));
                      });
              }
            }));
  }
}
