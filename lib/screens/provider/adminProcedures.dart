import 'package:cloud_firestore/cloud_firestore.dart';
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

    Future<List<dynamic>> getList() async{
    DocumentReference docRef = Firestore.instance.collection('procedures').document(
        appState?.firebaseUserAuth?.uid ?? "");

    // TODO: add a way to remove procedures from the list
    return docRef.get().then((datasnapshot) async{
      if (datasnapshot.exists){
        List<dynamic> info = datasnapshot.data['procedures'].toList();
        List<dynamic> list = new List();
        for(var uid in info){
          DocumentReference dr = Firestore.instance.collection('procedures').document(uid);
          DocumentSnapshot ds = await dr.get();
          list.add(ds);
        }
        return list;
      } else{
        return [];
      }
    });
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
                print('Add procedure');
                //we don't need procedure chooser here
                // Navigator.of(context).push(
                //   new MaterialPageRoute(builder: (BuildContext context){
                //     return new ProcedureChooser();
                //   },
                //     fullscreenDialog: true
                //   )
                // );
              },
            ),
          ],
          backgroundColor: Colors.white
          ),
       body: FutureBuilder(
         future: getList(),
         builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
           if(snapshot.connectionState == ConnectionState.waiting) {
             return Center(child: CircularProgressIndicator());
           } else {
             return Center(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final dynamic document = snapshot.data[index];
                  var name = "(No Name) " + document.documentID;
                  if (document.data != null) {
                    name = document.data["name"] ?? "";
                  }
                  if (name == " ") {
                    name = "(No Name) " + document.documentID;
                  }
                  return new Card(
                      child: ListTile(
                        leading: Icon(Icons.healing),
                        title: Text(name),
                        onTap: () {
                          print("Clicked Procedure: " + document.documentID);
                        }
                      )
                  );
                }),
              );
            }
          }
        ),
    ); 
      //ListView(
      //   children: <Widget>[
      //     Card(child: ListTile(
      //         leading: Icon(Icons.chevron_right),
      //         title: Text('Procedure #1'),
      //         subtitle: Text('Short description for procedure #1'),
      //         onTap: () {
      //           print("clicked Row");
      //         },
      //       )
      //     ),
      //     Card(child: ListTile(
      //       leading: Icon(Icons.chevron_right),
      //       title: Text('Procedure #2'),
      //       subtitle: Text('Short description for procedure #2'),
      //       onTap: () {
      //         print("clicked Row");
      //       },
      //     )
      //     ),
      //   ],
      // ),
    //);
  }
}
