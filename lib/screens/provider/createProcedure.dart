import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProcedure extends StatefulWidget{
  static const String id = 'create_procedure';
  final String userId;
  CreateProcedure({Key key, this.userId}) : super(key: key);
  @override
  _CreateProcedureState createState() => _CreateProcedureState(userId);
}

class _CreateProcedureState extends State<CreateProcedure>{
  StateModel appState;
  String userId;
  final db = Firestore.instance;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _descController = new TextEditingController();
  TextEditingController enddate = new TextEditingController(
    text: DateFormat("MM/dd/yyyy").format(DateTime.now()));
  _CreateProcedureState(this.userId);

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
        title: Text("Create a new procedure"),
        iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form( 
            child: ListView(
              children: <Widget>[
                Text("Procedure Name: "),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    ),
                ),
                Text("Procedure Description: "),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    ),
                ),
                Text("Procedure Date: "),
                SizedBox(width: 20.0),
                Container(
                  width: 100.0,
                  child: TextFormField(
                    controller: enddate,
                    decoration: new InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      DateTime now = new DateTime.now();
                      DateTime morning =
                          new DateTime(now.year, now.month, now.day);
                      print(DateTime(now.year + 1, now.month, now.day));
                      showDatePicker(
                              context: context,
                              initialDate:
                                  DateFormat("MM/dd/yyyy").parse(enddate.text),
                              firstDate: morning,
                              lastDate:
                                  DateTime(now.year + 1, now.month, now.day))
                          .then((value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (value != null) {
                          enddate.text = DateFormat("MM/dd/yyyy").format(value);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(onPressed: () async {
                    var procedure = { "name":_nameController.text, "description": _descController.text, "date": enddate.text };
                    db.collection("procedures").add(procedure).then((doc){
                      if(userId.isNotEmpty){
                        print("entering procedure add to patient");
                        db.collection("users").document(userId ?? "").updateData({'procedures':FieldValue.arrayUnion([doc.documentID])});
                      }
                    });
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    return;
                    },
                    child: Text('Submit')
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}