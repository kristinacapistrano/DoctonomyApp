import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

class PatientChooser extends StatefulWidget {
  static const String id = 'patient_chooser';
  List<dynamic> myUsers;
  PatientChooser({Key key, @required this.myUsers}) : super(key: key);

  @override
  _PatientChooserState createState() => _PatientChooserState(myUsers);
}

class _PatientChooserState extends State<PatientChooser> {
  StateModel appState;
  List<User> userList;
  List<dynamic> myUsers;

  _PatientChooserState(this.myUsers);

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            )),
            title: Text("Select a Patient"),
            iconTheme: IconThemeData(
              color: Colors.lightBlueAccent[700],
            ),
            backgroundColor: Colors.white),
        body: Column(children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {},
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              )),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("users")
                      //.where("firstName", isGreaterThanOrEqualTo: "")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        var users = List<DocumentSnapshot>();
                        snapshot.data.documents.forEach((ds) {
                          if (ds.data["admin"] == null || !ds.data["admin"]) {
                            if (!myUsers.contains(ds.documentID)) {
                              users.add(ds);
                            }
                          }
                        });
                        // TODO: hide patients that are already on the list
                        final int eventCount = users.length;
                        return new ListView.builder(
                            itemCount: eventCount,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot document = users[index];
                              var fName = document.data["firstName"] ?? "";
                              var lName = document.data["lastName"] ?? "";
                              var name = fName + " " + lName;
                              if (name == " ") {
                                name = "(No Name) " + document.documentID;
                              }
                              return new Card(
                                  child: ListTile(
                                      leading: Icon(Icons.face),
                                      title: Text(name),
                                      onTap: () {
                                        print("Add Patient: " +
                                            document.documentID);
                                        Firestore.instance
                                            .document(
                                                "users/${appState?.firebaseUserAuth?.uid}")
                                            .updateData({
                                          'patients': FieldValue.arrayUnion(
                                              [document.documentID])
                                        });
                                        Navigator.pop(context);
                                      }));
                            });
                    }
                  }))
        ]));
  }
}
