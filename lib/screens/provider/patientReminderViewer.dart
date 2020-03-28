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
import 'dart:math';


class PatientReminderViewer extends StatefulWidget {
  static const String id = 'patient_viewer';
  final List reminderList;
  final String title;
  PatientReminderViewer({Key key, @required this.reminderList, @required this.title}) : super(key: key);
  @override
  _PatientReminderViewerState createState() => _PatientReminderViewerState(reminderList, title);
}

class _PatientReminderViewerState extends State<PatientReminderViewer> {
  StateModel appState;
  List reminderList;
  String title;
  _PatientReminderViewerState(this.reminderList, this.title);
  var cron = new Cron();

  @override
  void initState() {
    super.initState();
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
              Builder(builder: (BuildContext context) {
                  List<Widget> tiles = reminderList.fold(List<Widget>(), (total, el) {
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
                  tiles.add(ListTile(title: Text("Add a reminder"), onTap: () {}, dense: true));
                  return Card(child: Column(children: tiles.toList()));
              })
            ]))
          )
    );
  }
}
