import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctonomy_app/screens/provider/createProcedure.dart';
import 'package:flutter/material.dart';
import '../../models/surgery.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';

class AdminProcedures extends StatefulWidget {
  static const String id = 'admin_home';

  _AdminProceduresState createState() => _AdminProceduresState();
}

class _AdminProceduresState extends State<AdminProcedures> {
  StateModel appState;
  List<Surgery> surgeryList;

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
              )
          ),
          title: Text("Procedures"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.blue,
              onPressed: () {
                print('Create new procedure');
                Navigator.of(context).push(
                  new MaterialPageRoute(builder: (BuildContext context){
                    return new CreateProcedure();
                  },
                    fullscreenDialog: true
                  )
                );
              },
            ),
          ],
          backgroundColor: Colors.white
          ),
       body: StreamBuilder<QuerySnapshot>(
         stream: Firestore.instance.collection("procedures").snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default: 
                var procedures = List<DocumentSnapshot>();
                snapshot.data.documents.forEach((ds){
                  procedures.add(ds);
                });
                final int count = procedures.length;
                return new ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = procedures[index];
                  var name = document.data["name"] ?? "";
                  var description = document.data["description"] ?? "";
                  return new Card(
                      child: ListTile(
                        leading: Icon(Icons.healing),
                        title: Text(name),
                        subtitle: Text(description),
                        onTap: () {
                          print("Clicked Procedure: " + document.documentID);
                          Firestore.instance.runTransaction((Transaction myTransaction) async {
                            await myTransaction.delete(snapshot.data.documents[index].reference);
                          });
                        }
                      )
                  );
                });
          }
        }
      )
    );
  }
}