import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/surgery.dart';

class ProcedureChooser extends StatefulWidget {
  static const String id = 'procedure_chooser';

  _ProcedureChooserState createState() => _ProcedureChooserState();
}

class _ProcedureChooserState extends State<ProcedureChooser> {
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
        textTheme: TextTheme(
          title: TextStyle (
            color: Colors.lightBlueAccent[700],
            fontSize:20,
            fontWeight: FontWeight.bold,
          ) 
        ),
        title: Text("Select a Procedure"),
        iconTheme: IconThemeData(
          color: Colors.lightBlueAccent[700],
        ),
        backgroundColor: Colors.white,
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
                itemBuilder: (context, index){
                  final DocumentSnapshot document = procedures[index];
                  var name = document.data["name"] ?? "";
                  var description = document.data["description"] ?? "";
                  return new Card(
                    child: ListTile(
                      leading: Icon(Icons.event),
                      title: Text(name),
                      subtitle: Text(description),
                      onTap: (){
                        print("Add procedure: " + document.documentID);
                        Firestore.instance.document("procedures/${appState?.firebaseUserAuth?.uid}").updateData({'procedures':FieldValue.arrayUnion([document.documentID])});
                      },
                    ),);
                });
          }

        }));
  }
}
