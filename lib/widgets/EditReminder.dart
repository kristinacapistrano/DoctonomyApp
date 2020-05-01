import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/state.dart';
import '../util/state_widget.dart';

class EditReminder extends StatefulWidget {
  static const String id = 'create_reminder';
  final String userId;
  final Map<String, dynamic> reminder;
  EditReminder({Key key, @required this.userId, @required this.reminder})
      : super(key: key);

  @override
  _EditReminderState createState() => _EditReminderState(userId, reminder);
}

class _EditReminderState extends State<EditReminder> {
  StateModel appState;
  String userId;

  Map<String, dynamic> reminder;
  _EditReminderState(this.userId, this.reminder);
  TextEditingController name = new TextEditingController(text: "");
  TextEditingController days = new TextEditingController(text: "1");
  TextEditingController time = new TextEditingController(
      text: DateFormat("h:mm a").format(DateTime.now()));
  TextEditingController enddate = new TextEditingController(
      text: DateFormat("MM/dd/yyyy").format(DateTime.now()));
  bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
    name.text = reminder["name"];
    days.text = reminder["interval"].toString();
    time.text =
        DateFormat("h:mm a").format(DateFormat("H:mm").parse(reminder["time"]));
    enddate.text =
        DateFormat("MM/dd/yyyy").format(reminder["endDateTime"].toDate());
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat("h:mm a");
    return format.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Edit Reminder", textAlign: TextAlign.left),
            Text("Note: Editing a reminder will reset the checklist",
                style: TextStyle(color: Colors.red, fontSize: 10.0),
                textAlign: TextAlign.left),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: name,
              decoration: new InputDecoration(
                hintText: 'Reminder Message',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (val) {
                if (val.isEmpty) {
                  _isButtonDisabled = true;
                } else {
                  _isButtonDisabled = false;
                }
                setState(() {});
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Every"),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    int d = int.parse(days.text) - 1;
                    days.text = max(d, 1).toString();
                  },
                ),
//                Text(days.text),
                Container(
                    width: 50.0,
                    child: TextField(
                        controller: days,
                        textAlign: TextAlign.center,
                        enabled: false)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {
                    days.text = (int.parse(days.text) + 1).toString();
                    setState(() {});
                  },
                ),
                Text("Day(s)"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("At"),
                SizedBox(width: 20.0),
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: time,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: 'Time',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  DateFormat("h:mm a").parse(time.text)))
                          .then((value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (value != null) {
                          time.text = formatTimeOfDay(value);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Until"),
                SizedBox(width: 20.0),
                Container(
                  width: 100.0,
                  child: TextField(
                    controller: enddate,
                    textAlign: TextAlign.center,
                    decoration: new InputDecoration(
                      hintText: 'Date',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      DateTime now = new DateTime.now();
                      DateTime morning =
                          new DateTime(now.year, now.month, now.day);
                      print(DateTime(now.year + 1, now.month, now.day));
                      showDatePicker(
                              context: context,
                              initialDate:
                                  DateFormat("MM/dd/yyyy").parse(enddate.text),
                              firstDate: morning,
                              lastDate:
                                  DateTime(now.year + 1, now.month, now.day))
                          .then((value) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                        if (value != null) {
                          enddate.text = DateFormat("MM/dd/yyyy").format(value);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FlatButton(
              child: new Text("Cancel"),
              onPressed: () => Navigator.of(context).pop()),
          FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                Firestore.instance
                    .collection('reminders')
                    .document(userId)
                    .setData({
                  'reminders': FieldValue.arrayRemove([reminder])
                }, merge: true).then((_) {
                  Navigator.of(context).pop(true);
                });
              }),
          FlatButton(
              child: new Text("Save"),
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      Firestore.instance
                          .collection('reminders')
                          .document(userId)
                          .setData({
                        'reminders': FieldValue.arrayRemove([reminder])
                      }, merge: true).then((_) {
                        DateTime startdatetime = reminder["startDateTime"].toDate();
                        DateTime timeDate = DateFormat("HH:mm").parse(time.text);
                        DateTime nextTriggerDate = DateTime(
                          startdatetime.year,
                          startdatetime.month,
                          startdatetime.day,
                          timeDate.hour,
                          timeDate.minute,
                        );
                        var myReminder = {
                          'endDateTime': DateFormat("MM/dd/yyyy HH:mm:ss")
                              .parse(enddate.text + " 23:59:59").toLocal(),
                          'startDateTime': startdatetime,
                          'time': DateFormat("H:mm a")
                              .format(DateFormat("h:mm a").parse(time.text)),
                          'name': name.text,
                          'interval': int.parse(days.text),
                          'checklist': [],
                          'uid': userId,
                          'nextTriggerDate': nextTriggerDate,
                        };
                        Firestore.instance
                            .collection('reminders')
                            .document(userId)
                            .setData({
                          'reminders': FieldValue.arrayUnion([myReminder])
                        }, merge: true).then((_) {
                          Navigator.of(context).pop(true);
                        });
                      });
                    })
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))));
  }
}
