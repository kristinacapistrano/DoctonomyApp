
import 'package:doctonomy_app/widgets/NotificationWidget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:intl/intl.dart';
import 'ReminderListViewer.dart';
import 'dart:math';


class PatientHome extends StatefulWidget {
  static const String id = 'patient_home';

  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  final Firestore _firestore = Firestore.instance; //_db
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging(); //fcm

  var cron = new Cron();
  StateModel appState;
  String title = "";
  List<Allergy> allergies = new List();
  Map<String,String> allergyMap = new Map();
  @override
  void initState() {
    super.initState();
    //use alert dialog
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
            context: context,
          builder: (context)=> AlertDialog(
            content: ListTile(
              //will display notification title from firebase console
              title: Text(message['this is title']['title']),
              //will display notification text from firebase console
              subtitle: Text(message['this is body']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: ()=> Navigator.of(context).pop(),
              )
            ],
          )
        );
      },
      //executes when app is closed
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );


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
  
  Future<Map<String,dynamic>> getUserReminders() async {
    DocumentReference docRef = Firestore.instance.collection('reminders').document(appState?.firebaseUserAuth?.uid);
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data;
      } else {
        return null;
      }
    });
  }

  String timeToString(date) {
    return DateFormat("h:mm a").format(DateFormat("H:mm").parse(date));
  }

  String dtToString(date) {
    return DateFormat("MM/dd/yyyy").format(date);
  }

  List getAllDates(startdate, enddate, time, interval) {
    List dates = [];
    DateTime daytime = DateFormat("H:mm").parse(time);
    DateTime tempdate = new DateTime(startdate.year, startdate.month, startdate.day, daytime.hour, daytime.minute, 0, 0, 0);
    while(tempdate.isBefore(enddate)) {
      dates.add(tempdate);
      tempdate = new DateTime(tempdate.year, tempdate.month, tempdate.day + interval, daytime.hour, daytime.minute, 0, 0, 0);
    }
    return dates;
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
                          FutureBuilder(
                              future: getUserReminders(),
                              builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else {
                                  print(snapshot.data);
                                  return Builder(builder: (BuildContext context) {
                                    List reminderList = (snapshot?.data ?? Map())["reminders"]?.toList() ?? [];
                                    if (reminderList.length > 0) {
                                      List<Widget> tiles = reminderList.sublist(0, min(3, reminderList.length)).fold(List<Widget>(), (total, el) {
                                        int interval = el["interval"];
                                        var intervalText = "Every day";
                                        if (interval > 1) {
                                          intervalText = "Every " + interval.toString() + " days";
                                        }

                                        var time = el["time"];
                                        var timesText = " at " + timeToString(time);

                                        DateTime startdate = el["startDateTime"].toDate();
                                        DateTime enddate = el["endDateTime"].toDate();

                                        String start = dtToString(startdate);
                                        String end = dtToString(enddate);

                                        DateTime td = new DateTime.now();
                                        DateTime today = DateTime(td.year, td.month, td.day, 23, 59, 59);

                                        List alldates = getAllDates(startdate, enddate, time, interval);
                                        bool cutoff = alldates.length > 7;
                                        if (cutoff == true) {
                                          List bdates = alldates.where((x) => today.isAfter(x)).toList();
                                          List adates = alldates.where((x) => today.isBefore(x)).toList();
                                          alldates = List();
                                          bool flipper = true;
                                          while(alldates.length < 7) {
                                            if (flipper) {
                                              if (bdates.length > 0)
                                                alldates.insert(0, bdates.removeLast());
                                            } else {
                                              if (adates.length > 0)
                                                alldates.add(adates.removeAt(0));
                                            }
                                            flipper = !flipper;
                                          }
                                        }

                                        List<Widget> dateitems = alldates.expand((dateel) {
                                          bool isfuture = today.isBefore(dateel);
                                          bool checked = !isfuture && el["checklist"].contains(DateFormat("MM/dd/yyyy").format(dateel));
                                          Column col = Column(children: <Widget>[SizedBox(
                                              height: 24.0,
                                              width: 24.0,
                                              child:
                                              Opacity(
                                                opacity: isfuture ? 0.2 : 1.0,
                                                child: Checkbox(value: checked, onChanged: (val) {
                                                  if (val) {
                                                    List checklist = el["checklist"].toList();
                                                    checklist.add(DateFormat("MM/dd/yyyy").format(dateel));
                                                    reminderList[reminderList.indexOf(el)]["checklist"] = checklist;
                                                    Firestore.instance.collection('reminders').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'reminders':reminderList}).then((_) {
                                                      setState(() {});
                                                    });
                                                  } else {
                                                    List checklist = el["checklist"].toList();
                                                    checklist.remove(DateFormat("MM/dd/yyyy").format(dateel));
                                                    reminderList[reminderList.indexOf(el)]["checklist"] = checklist;
                                                    Firestore.instance.collection('reminders').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'reminders':reminderList}).then((_) {
                                                      setState(() {});
                                                    });
                                                  }
                                                }),
                                              )
                                          ), Text(DateFormat("MM/dd").format(dateel))]);
                                          return [Expanded(child: col), Container(width: 1, height: 20, color: Colors.grey)];
                                        }).toList();
                                        dateitems.removeLast();

                                        if (cutoff == true) {
                                          dateitems.add(Container(width: 60, child: FlatButton(child: Text("See\nAll", style: TextStyle(color: Colors.blue, fontSize: 11.0 ), textAlign: TextAlign.center), onPressed: () {
                                            showDialog(context: context, builder: (context) {
                                              List<Widget> alldateitems = getAllDates(startdate, enddate, time, interval).map((dateel) {
                                                bool isfuture = today.isBefore(dateel);
                                                bool checked = !isfuture && el["checklist"].contains(DateFormat("MM/dd/yyyy").format(dateel));
                                                return Column(children: <Widget>[SizedBox(height: 24.0, width: 24.0, child: Opacity(opacity: isfuture ? 0.2 : 1.0, child: Checkbox(value: checked, onChanged: (val) {
                                                  if (val) {
                                                    List checklist = el["checklist"].toList();
                                                    checklist.add(DateFormat("MM/dd/yyyy").format(dateel));
                                                    reminderList[reminderList.indexOf(el)]["checklist"] = checklist;
                                                    Firestore.instance.collection('reminders').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'reminders':reminderList}).then((_) {
                                                      setState(() {});
                                                      Navigator.of(context).pop();
                                                    });
                                                  } else {
                                                    List checklist = el["checklist"].toList();
                                                    checklist.remove(DateFormat("MM/dd/yyyy").format(dateel));
                                                    reminderList[reminderList.indexOf(el)]["checklist"] = checklist;
                                                    Firestore.instance.collection('reminders').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'reminders':reminderList}).then((_) {
                                                      setState(() {});
                                                      Navigator.of(context).pop();
                                                    });
                                                  }
                                                }))
                                                ), Text(DateFormat("MM/dd").format(dateel), style: TextStyle(fontSize: 12.0),)]);
                                              }).toList();
                                              return AlertDialog(
                                                title: Text(el["name"] + " - Checklist"),
                                                content: Container(height: 1000, width: 200, child: GridView.count(
                                                    crossAxisCount: 4,
                                                    children: alldateitems
                                                )),
                                                actions: <Widget>[FlatButton(child: Text('Done'), onPressed: () {Navigator.of(context).pop();})],
                                              );
                                            });
                                          })));
                                        }

                                        total.add(ListTile(
                                            title: Text(el["name"], style: TextStyle(fontWeight: FontWeight.w500)),
                                            subtitle: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(intervalText + timesText + "\nFrom " + start + " until " + end.toString() + "\n"),
                                                Row(children: dateitems)
                                              ],
                                            ),
                                            dense: true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            onTap: () {
//                                              showDialog(
//                                                  context: context,
//                                                  builder: (context) {
//                                                    return EditReminder(userId: appState?.firebaseUserAuth?.uid, reminder: Map<String, dynamic>.from(el));
//                                                  }).then((val) {
//                                                setState(() {});
//                                              });
                                            }));
                                        total.add(Divider(thickness: 1, indent: 10, endIndent: 10, height: 1));
                                        return total;
                                      });
                                      tiles.add(ListTile(title: Text("See All"), onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                              return new ReminderListViewer(title: "My Reminders");
                                            }, fullscreenDialog: true
                                            ));
                                      }, dense: true));
                                      return Card(child: Column(children: tiles.toList()));
                                    } else {
                                      return Card(child: ListTile(
                                          title: Text("No Reminders have been created by your provider yet"),
                                          onTap: () {
//                                            showDialog(
//                                                context: context,
//                                                builder: (context) {
//                                                  return CreateReminder(userId: appState?.firebaseUserAuth?.uid);
//                                                }).then((val) {
//                                              if (val != null) {
//                                                setState(() {});
//                                              }
//                                            });
                                          },
                                          dense: true
                                      )
                                      );
                                    }
                                  });
                                }
                              }
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
