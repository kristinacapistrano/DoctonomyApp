import 'package:doctonomy_app/widgets/CreateReminder.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';
//import 'package:cloud_functions/cloud_functions.dart';
import 'package:cron/cron.dart';
import '../../widgets/AlertTextbox.dart';
import './patientReminderViewer.dart';
import '../../widgets/CreateReminder.dart';
import 'dart:math';


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

  Future<Map<String,dynamic>> getUserReminders() async {
    DocumentReference docRef = Firestore.instance.collection('reminders').document(userId ?? "");
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data;
      } else {
        return null;
      }
    });
  }

  String timesToString(times) {
    var tempTimes = times.toList();
    if (tempTimes.length == 0) {
      return "";
    }
    var timeStr = timeToString(tempTimes.removeLast());
    if (times.length > 2) {
      return " at " + tempTimes.map((t) => timeToString(t)).join(', ') + ', and ' + timeStr;
    } else if (times.length > 1) {
      return " at " + timeToString(tempTimes.removeLast())+ ' and ' + timeStr;
    }
    return " at " + timeStr;
  }

  String timeToString(date) {
    return DateFormat("h:mm a").format(DateFormat("H:mm").parse(date));
  }

  String dtToString(date) {
    return DateFormat("MM/dd/yyyy").format(date);
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
                          Card(child: ListTile(
                            trailing: Icon(Icons.healing),
                            title: Text('Schedule new procedure'),
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

                                        var times = el["times"];
                                        var timesText = "";
                                        if (interval == 1) {
                                          timesText = timesToString(times);
                                        } else if (interval > 1 && times.length == 1) {
                                          timesText = " at " + timeToString(times[0]);
                                        }

                                        String start = dtToString(el["startDateTime"].toDate());
                                        String end = dtToString(el["endDateTime"].toDate());

                                        total.add(ListTile(
                                            title: Text(el["name"], style: TextStyle(fontWeight: FontWeight.w500)),
                                            subtitle: Text(intervalText + timesText + "\nFrom " + start + " until " + end.toString()),
                                            dense: true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                            onTap: () {}));
                                        total.add(Divider(thickness: 1, indent: 10, endIndent: 10, height: 1));
                                        return total;
                                      });
                                      tiles.add(ListTile(title: Text("See All"), onTap: () {

                                        Navigator.of(context).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                              return new PatientReminderViewer(reminderList: reminderList, title: title);
                                            }, fullscreenDialog: true
                                        ));

                                      }, dense: true));
                                      return Card(child: Column(children: tiles.toList()));
                                    } else {
                                      return Card(child: ListTile(
                                          title: Text("No Reminders (Click here to add)"),
                                          onTap: () {
                                            showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CreateReminder(userId: userId);
                                            }).then((val) {
                                              if (val != null) {
                                                print("Reminder Created");
                                              }
                                            });
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
                                          Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':allergyList}).then((_) {
                                            setState(() {});
                                          });
                                          Navigator.of(context).pop();
                                        }, (val) {
                                          Navigator.of(context).pop();
                                        }, (val) {
                                          allergyList[allergyList.indexOf(el)] = val;
                                          Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':allergyList}).then((_) {
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
                                        Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':FieldValue.arrayUnion([val])}).then((_) {
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
                                          Firestore.instance.collection('users').document(userId ?? "").updateData({'allergies':FieldValue.arrayUnion([val])}).then((_) {
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
