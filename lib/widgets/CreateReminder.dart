import 'package:flutter/material.dart';
import '../util/state_widget.dart';
import '../models/state.dart';
import 'dart:math';

class CreateReminder extends StatefulWidget {
  static const String id = 'create_reminder';
  final String userId;
  CreateReminder({Key key, @required this.userId}) : super(key: key);

  @override
  _CreateReminderState createState() => _CreateReminderState(userId);
}

class _CreateReminderState extends State<CreateReminder> {
  StateModel appState;
  String userId;
  _CreateReminderState(this.userId);
  TextEditingController name = new TextEditingController();
  TextEditingController days = new TextEditingController();

//  final String name;
//  final String startDate;
//  final String endDate;
//  final int interval;
//  final List<String> times;
  @override
  void initState() {
    super.initState();
    days.text = "1";
    name.text = "";
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;

    return AlertDialog(
        title: Text("New Reminder"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: name,
              decoration: new InputDecoration(
                hintText: 'Reminder',
                hintStyle: TextStyle(color: Colors.grey),
              ),
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
                    days.text = max(d,1).toString();
                  },
                ),
//                Text(days.text),
                Container(
                    width: 50.0,
                    child: TextField(
                      controller: days,
                      textAlign: TextAlign.center,
                      enabled: false
                    )
                ),
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
//            Text("Every Day"),
//            TextField(
//              controller: name,
//              decoration: new InputDecoration(
//                hintText: 'Every _ days',
//                hintStyle: TextStyle(color: Colors.grey),
//              ),
//            )
            //Todo add fields for startDate, endDate, and times
          ],
        ),
        actions: [
          FlatButton(child: new Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
          FlatButton(child: new Text("Done"), onPressed: () => Navigator.of(context).pop("something"))
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))
    );
  }
}