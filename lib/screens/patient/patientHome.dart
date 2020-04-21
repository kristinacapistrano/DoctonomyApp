
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/AlertTextbox.dart';
import 'package:cron/cron.dart';
import 'package:doctonomy_app/models/reminder.dart';
import 'package:doctonomy_app/models/constants.dart';
import '../../models/allergy.dart';



class PatientHome extends StatefulWidget {
  static const String id = 'patient_home';

  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  var cron = new Cron();
  StateModel appState;
  String title = "";
  List<Allergy> allergies = new List();
  Map<String,String> allergyMap = new Map();
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
            centerTitle: false,
            title: FittedBox(fit:BoxFit.fitWidth,
                child: Text("My Information"),
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
                            leading: Icon(Icons.healing, color: Colors.red),
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
                            leading: PopupMenuButton(
                              onSelected: choiceAction,
                                icon: Icon(
                                    Icons.alarm_add,
                                    color: Colors.blue,
                                    ),

                                itemBuilder: (BuildContext context){
                                return Constants.choices.map((String choice){
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              }),
                            title: Text('Take medication'),
                            subtitle: Text('testing'),
                            onTap: () {
                              /* cron.schedule(new Schedule.parse(_time), () async {
                                    //send notification everytime selectedtime is now
                               });
                                */
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
                                            Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList}).then((_) {
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
                                                Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList});
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
                                              Firestore.instance.collection("users").document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList});
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
                                                Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList});
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
                                              Firestore.instance.collection("users").document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList});
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
                        ],

                      ),

                    );
                  }
                }
            )

        )
    );
  }

  Future<Null> selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2021));

      if (picked != null && picked != date) {
        setState(() {
          date = picked;
          print(date.toString());
        });
      }

  }

  void _showMultiSelect(BuildContext context) async {
    final items = <Reminder<int>>[
      Reminder(1, 'Monday'),
      Reminder(2, 'Tuesday'),
      Reminder(3, 'Wednesday'),
      Reminder(4, 'Thursday'),
      Reminder(5, 'Friday'),
      Reminder(6, 'Saturday'),
      Reminder(7, 'Sunday'),
    ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return ReminderMultiSelectDialog(
          items: items,
          //initialSelectedValues: [1, 3].toSet(), this is if you want something to be preselected
        );
      },
    );

    print(selectedValues);
  }


  Future<Null> selectTime(BuildContext context) async {
    TimeOfDay time = TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(context: context,
        initialTime: time);
    if ( picked != null && picked != time)
      setState(() {
        time = picked;
        print(time.toString());

      });

  }
  void choiceAction(String choice){
    if(choice == Constants.selectDay){
      print('Selecting Day');
      _showMultiSelect(context);
    }else if(choice == Constants.selectTime){
      print('Selecting Time');
      selectTime(context);

    }
  }
}
