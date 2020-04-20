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
import '../../widgets/EditReminder.dart';
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
                                                child: Checkbox(value: checked, onChanged: (_) {}),
                                              )
                                          ), Text(DateFormat("MM/dd").format(dateel))]);
                                          return [Expanded(child: col), Container(width: 1, height: 20, color: Colors.grey)];
                                        }).toList();
                                        dateitems.removeLast();

                                        if (cutoff == true) {
                                          dateitems.add(Container(width: 60, child: FlatButton(child: Text("See\nAll", style: TextStyle(color: Colors.blue, fontSize: 11.0 ), textAlign: TextAlign.center), onPressed: () {
                                            //todo show all checklist
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
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditReminder(userId: userId, reminder: Map<String, dynamic>.from(el));
                                                  }).then((val) {
                                                setState(() {});
                                              });
                                            }));
                                        total.add(Divider(thickness: 1, indent: 10, endIndent: 10, height: 1));
                                        return total;
                                      });
                                      tiles.add(ListTile(title: Text("See All"), onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(builder: (BuildContext context) {
                                              return new PatientReminderViewer(title: title, userId: userId);
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
                                                setState(() {});
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
