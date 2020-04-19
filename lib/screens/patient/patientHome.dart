
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';
import 'package:doctonomy_app/models/reminder.dart';
import 'package:doctonomy_app/models/constants.dart';

//import 'package:doctonomy_app/widgets/NotificationWidget.dart';
import '../../widgets/AlertTextbox.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';

import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';



class PatientHome extends StatefulWidget {
  static const String id = 'patient_home';


  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  //final Firestore _firestore = Firestore.instance; //_db
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging(); //fcm
  var cron = new Cron();
  StateModel appState;
  String title = "";


  @override
  void initState() {
    super.initState();

    /**
     * uses alert text box for notification to let users know they have to
     * give attention to notification
     * uses firebase console to control notifications at the moment.
     * notification cannot yet be controlled by code from the app.
     */
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
                            subtitle: Text('testing local noti'),
                            onTap: () async{

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
                          Builder(builder: (BuildContext context) {
                            var allergyList = snapshot.data["allergies"]?.toList() ?? [];
                            if (allergyList.length > 0) {
                              List<Widget> tiles = allergyList.fold(List<Widget>(), (total, el) {
                                total.add(ListTile(title: Text(el, style: TextStyle(fontWeight: FontWeight.w500)), dense: true, onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertTextbox("Edit Allergy", null, el, "Delete", "Cancel", "Save", (val) {
                                          allergyList.removeAt(allergyList.indexOf(el));
                                          Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList}).then((_) {
                                            setState(() {});
                                          });
                                          Navigator.of(context).pop();
                                        }, (val) {
                                          Navigator.of(context).pop();
                                        }, (val) {
                                          allergyList[allergyList.indexOf(el)] = val;
                                          Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':allergyList}).then((_) {
                                            setState(() {});
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
                                        Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':FieldValue.arrayUnion([val])}).then((_) {
                                          setState(() {});
                                        });
                                        Navigator.of(context).pop();
                                      });
                                    });
                              }));
                              return Card(child: Column(children: tiles.toList()));
                            } else {
                              return Card(child: ListTile(
                                  title: Text("No Allergies (Click here to add)"),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertTextbox("Add Allergy", null, "", null, "Cancel", "Add", null, (val) {
                                            Navigator.of(context).pop();
                                          }, (val) {
                                            Firestore.instance.collection('users').document(appState?.firebaseUserAuth?.uid ?? "").updateData({'allergies':FieldValue.arrayUnion([val])}).then((_) {
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
