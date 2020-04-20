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
import '../../widgets/CreateReminder.dart';
import '../../widgets/EditReminder.dart';
import 'dart:math';


class PatientReminderViewer extends StatefulWidget {
  static const String id = 'patient_viewer';
  final String title;
  final String userId;
  PatientReminderViewer({Key key, @required this.title, @required this.userId}) : super(key: key);
  @override
  _PatientReminderViewerState createState() => _PatientReminderViewerState(title, userId);
}

class _PatientReminderViewerState extends State<PatientReminderViewer> {
  StateModel appState;
  String title;
  String userId;
  _PatientReminderViewerState(this.title, this.userId);
  var cron = new Cron();

  @override
  void initState() {
    super.initState();
  }

  String timeToString(date) {
    return DateFormat("h:mm a").format(DateFormat("H:mm").parse(date));
  }

  String dtToString(date) {
    return DateFormat("MM/dd/yyyy").format(date);
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
                child: Text(title + "'s Reminders")
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
        body:
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Center(
            child: ListView(
            children: <Widget>[
              SizedBox(height: 20.0),

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
                          List<Widget> tiles = reminderList.fold(List<Widget>(), (total, el) {
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
                                List<Widget> alldateitems = getAllDates(startdate, enddate, time, interval).map((dateel) {
                                  bool isfuture = today.isBefore(dateel);
                                  bool checked = !isfuture && el["checklist"].contains(DateFormat("MM/dd/yyyy").format(dateel));
                                  return Column(children: <Widget>[SizedBox(height: 24.0, width: 24.0, child: Opacity(opacity: isfuture ? 0.2 : 1.0, child: Checkbox(value: checked, onChanged: (_) {}),                                   )
                                  ), Text(DateFormat("MM/dd").format(dateel), style: TextStyle(fontSize: 12.0),)]);
                                }).toList();

                                showDialog(context: context, builder: (context) {
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
                          tiles.add(ListTile(title: Text("Add a reminder"), onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CreateReminder(userId: userId);
                                }).then((val) {
                                setState(() {});
                            });
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
            ]))
          )
    );
  }
}
