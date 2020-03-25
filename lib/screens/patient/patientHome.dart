import 'dart:math';

import 'package:flutter/material.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../widgets/AlertTextbox.dart';
import 'package:cron/cron.dart';
import 'package:doctonomy_app/screens/patient/reminderDateTimePicker.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:calendarro/calendarro.dart';
import 'package:flutter/cupertino.dart';


class PatientHome extends StatefulWidget {
  static const String id = 'patient_home';

  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  var cron = new Cron();
  StateModel appState;
  String title = "";
  DateTime _dateTime = DateTime.now();

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
                child: Text("My Info")
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

                          SizedBox(height: 20.0),
                          Text('Reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                          //TODO remove hardcoded card
                          Card(child: ListTile(
                            leading: Icon(Icons.alarm),
                            title: Text('Take medication'),
                            subtitle: Text('Every day at 5pm'),
                            onTap: () {
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (BuildContext context){
                                    return new ReminderDateTimePicker();
                                  },
                                      fullscreenDialog: true
                                  )
                              );

                              /*String _time = ""; //need the string value from selectTime
                              String _date = "";
                             createSetReminderDialog(context).then((onValue){
                               print("clicked Row"); //---- probably not needed at all in this

                              });
                              //selectDate(context);
                              //selectTime(context);
                               cron.schedule(new Schedule.parse(_time), () async {
                                    //send notification everytime selectedtime is now
                               });*/

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

  /*Method is for setting reminder ,  patients will be able to use this*/
  /*method not used yet*/
  Future<String> createSetReminderDialog(BuildContext context){
    TextEditingController userController = TextEditingController();
    return showDialog(context: context, builder: (context){
      {
        return AlertDialog(
          title: Text("Set date and time"),
          content: TextField(
            controller: userController,
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text('Set'),
              onPressed: (){
                Navigator.of(context).pop(userController.text.toString());

              },
            )
          ],
        );
      }});
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

}
