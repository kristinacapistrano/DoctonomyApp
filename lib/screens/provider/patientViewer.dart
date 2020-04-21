import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
//import 'package:cloud_functions/cloud_functions.dart';
import 'package:cron/cron.dart';
import '../../widgets/AlertTextbox.dart';
import '../../models/allergy.dart';


class PatientViewer extends StatefulWidget {
  static const String id = 'patient_viewer';
  final String userId;
  final String title;
  PatientViewer({Key key, @required this.userId, @required this.title}) : super(key: key);
  @override
  _PatientViewerState createState() => _PatientViewerState(userId, title);
}

class _PatientViewerState extends State<PatientViewer> {
  StateModel appState;
  String userId;
  String title;
  List<Allergy> allergies = new List();
  Map<String,String> allergyMap = new Map();
  _PatientViewerState(this.userId, this.title);
  var cron = new Cron();
  @override
  void initState() {
    super.initState();
  }

  Future<Map<String,dynamic>> getUserData() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(userId ?? "");
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data;
      } else {
        return null;
      }
    });
  }

  List<Allergy> _allergyListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Allergy(
        id: doc.documentID,
        name: doc.data['name'] ?? '',
        type: doc.data['type'] ?? ''
      );
    }).toList();
  }

  Map<String, String> _allergyMapFromList(List<Allergy> list){
    Map<String, String> ret = new Map();
    for(var al in list){
      ret.putIfAbsent(al.id, () => al.name);
    }
    return ret;
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
                child: Text(title)
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
                          Card(child: ListTile(
                            leading: Icon(Icons.healing),
                            title: Text('Procedure #2'),
                            subtitle: Text('Coming up on 5/05/20'),
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
                              cron.schedule(new Schedule.parse('*/1 * * * *'), () async {
                                print('every 1 minute');
                              });
                              /*CloudFunctions.instance.getHttpsCallable(
                                functionName: "patientReminder",
                                //no money for blaze upgrade
                                );
                              print ("reminding every 5pm");*/
                            },
                          )
                          ),

                          //Allergy information
                          SizedBox(height: 20.0),
                          Text('Allergies', style: TextStyle(fontWeight: FontWeight.w500)),
                          StreamBuilder (
                            stream: Firestore.instance.collection('allergies').snapshots(),
                            builder: (context, querysnapshot) {
                              allergies = _allergyListFromSnapshot(querysnapshot.data);
                              allergyMap = _allergyMapFromList(allergies);
                              List<dynamic> allergyList = snapshot.data["allergies"]?.toList() ?? []; 
                              String name;
                              if (allergyList.length > 0) {//if patient has allergies already in their list...
                                List<Widget> tiles = allergyList.fold(List<Widget>(), (total, el) {
                                  name = allergyMap[el] ?? "";
                                  total.add(ListTile(title: Text(name, style: TextStyle(fontWeight: FontWeight.w500)), dense: true, onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertTextbox("Edit Allergy", null, name, "Delete", "Cancel", "Save", (name) {//delete
                                            allergyList.removeAt(allergyList.indexOf(el));
                                            Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':allergyList}).then((_) {
                                              setState(() {});
                                            });
                                            Navigator.of(context).pop(); //after delete
                                          }, (val) {// cancel
                                            Navigator.of(context).pop(); // cancel
                                          }, (val) {
                                            Firestore.instance.collection('allergies').document(el ?? "").updateData({"name":val}).then((_){
                                              setState((){});
                                            });
                                            Navigator.of(context).pop();
                                          });
                                        });
                                  }));
                                  total.add(Divider(thickness: 1, indent: 10, endIndent: 10, height: 1));
                                  return total;
                                });
                                tiles.add(ListTile(title: Text("+ Add New"), dense: true, onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertTextbox("Add Allergy", null, "", null, "Cancel", "Add", null, (val) {
                                          Navigator.of(context).pop();
                                        }, (val) {
                                          print('beginning add functionality');
                                          Firestore.instance.collection('allergies').where("name", isEqualTo: val).getDocuments().then((query){
                                            if(query.documents.isEmpty){
                                              Firestore.instance.collection("allergies").add({"name":val}).then((doc){
                                                allergyList.add(doc.documentID);
                                              }).then((_){
                                                Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':allergyList});
                                                setState(() {});
                                              }).catchError((e){
                                                print(e);
                                              });
                                            } else {
                                              print("query not empty");
                                              List<String> keys = allergyMap.keys.toList();
                                              print(keys);
                                              for(var key in keys){
                                                if(allergyMap[key] == val) {
                                                  allergyList.add(key);
                                                  break;
                                                }
                                              }
                                              Firestore.instance.collection("users").document(userId ?? "").updateData({'allergies':allergyList});
                                            }
                                          setState(() {});
                                          });
                                          Navigator.of(context).pop();
                                        });
                                      });
                                }));
                                return Card(child: Column(children: tiles.toList()));
                              } else { //else -> User Allergy list is empty; carry out instructions below.
                                return Card(child: ListTile(
                                  title: Text("No Allergies (Click here to add)"),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertTextbox("Add Allergy", null, "", null, "Cancel", "Add", null, (val) {
                                            Navigator.of(context).pop();
                                          }, (val) {
                                              print('beginning add functionality');
                                          Firestore.instance.collection('allergies').where("name", isEqualTo: val).getDocuments().then((query){
                                            if(query.documents.isEmpty){
                                              Firestore.instance.collection("allergies").add({"name":val}).then((doc){
                                                allergyList.add(doc.documentID);
                                              }).then((_){
                                                Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':allergyList});
                                                setState(() {});
                                              }).catchError((e){
                                                print(e);
                                              });
                                            } else {
                                              print("query not empty");
                                              List<String> keys = allergyMap.keys.toList();
                                              print(keys);
                                              for(var key in keys){
                                                if(allergyMap[key] == val) {
                                                  allergyList.add(key);
                                                  break;
                                                }
                                              }
                                              Firestore.instance.collection("users").document(userId ?? "").updateData({'allergies':allergyList});
                                            }
                                          setState(() {});
                                          });
                                          Navigator.of(context).pop();
                                          });
                                        });
                                  },
                                  dense: true
                                )
                                );
                              }
                          }),

                          SizedBox(height: 20.0),
                          Text('Actions', style: TextStyle(fontWeight: FontWeight.w500)),
                          Card(child: ListTile(
                            trailing: Icon(Icons.send),
                            title: Text('Send a message'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),
                          Card(child: ListTile(
                            trailing: Icon(Icons.healing),
                            title: Text('Schedule new procedure'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),
                          Card(child: ListTile(
                            trailing: Icon(Icons.clear),
                            title: Text('Remove from my list'),
                            onTap: () {
                              Firestore.instance.document("users/${appState?.firebaseUserAuth?.uid}").updateData({'patients': FieldValue.arrayRemove([userId])});
                              Navigator.pop(context);
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
