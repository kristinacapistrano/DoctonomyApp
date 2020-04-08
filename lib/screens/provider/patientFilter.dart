import 'package:doctonomy_app/screens/provider/patientViewer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

class PatientFilter extends StatefulWidget {
  static const String id = 'patient_filter';
  List<dynamic> myUsers;
  PatientFilter({Key key, @required this.myUsers}) : super(key: key);

  @override
  _PatientFilterState createState() => _PatientFilterState(myUsers);
}

class _PatientFilterState extends State<PatientFilter> {
  StateModel appState;
  List<dynamic> userList;
  List<dynamic> myUsers;
  List <String> _criteria = ['a', 'b', 'c', 'd'];
  List <String> _criteria2 = ['1', '2', '3', '4'];
  String _selectedCriteria1;
  String _selectedCriteria2;
  Future<List<String>> _allergies;
  List<String> _medications;

  _PatientFilterState(this.myUsers);

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> getUserList() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(
        appState?.firebaseUserAuth?.uid ?? "");
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        userList = datasnapshot.data['patients'].toList();
        List<dynamic> list = new List();
        for(var uid in userList) {
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
  
  Future<List<String>> getCriteriaList(String criteria) async {
    DocumentReference docRef = Firestore.instance.collection(criteria).document(
        appState?.firebaseUserAuth?.uid ?? "");
        return docRef.get().then((datasnapshot) {
          if(datasnapshot.exists){
            List<String> _list;
            datasnapshot.data.forEach((key, value){
              if(key == "name") _list.add(value);
            });
            return _list;
          } else return [];
        });
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 8;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.lightBlueAccent[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          title: Text("Filter Patients"),
          iconTheme: IconThemeData(
            color: Colors.lightBlueAccent[700],
          ),
          backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50, // constrain height
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 0.0,
                crossAxisCount: 2,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("allergies").snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData){
                        Text("Loading");
                      } else {
                        List <DropdownMenuItem> names = [];
                        for(var i = 0; i < snapshot.data.documents.length; i++){
                          DocumentSnapshot data = snapshot.data.documents[i];
                          names.add(
                            DropdownMenuItem(
                              child: Text(data.documentID),
                              value: "${data.documentID}",
                            )
                          );
                        }
                        return DropdownButton(
                          isExpanded: true,
                          hint: Text("Allergies"),
                          value: _selectedCriteria1, 
                          onChanged: (newName){
                            setState(() {
                              _selectedCriteria1 = newName;
                            });
                          },
                          items: names,
                          );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("medications").snapshots(),
                    builder:(context, snapshot){
                      if(!snapshot.hasData){
                        Text("Loading");
                      } else {
                        List <DropdownMenuItem> names = [];
                        for(var i = 0; i < snapshot.data.documents.length; i++){
                          DocumentSnapshot data = snapshot.data.documents[i];
                          names.add(
                            DropdownMenuItem(
                              child: Text(data.documentID),
                              value: "${data.documentID}",
                            )
                          );
                        }
                        return DropdownButton(
                          isExpanded: true,
                          hint: Text("Medications"),
                          value: _selectedCriteria2, 
                          onChanged: (newName){
                            setState(() {
                              _selectedCriteria2 = newName;
                            });
                          },
                          items: names,
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            Text("The rest of the content can go below these dropdowns"),
            FutureBuilder(
            future: getUserList(),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: ListView.builder(
                      shrinkWrap: true,
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
          ]
        )
      )
    );
  }
}