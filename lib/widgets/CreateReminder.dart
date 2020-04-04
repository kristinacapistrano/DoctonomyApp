import 'package:flutter/material.dart';
import 'dart:math';

class CreateReminder extends AlertDialog {
  final String userId;

//  final String name;
//  final String startDate;
//  final String endDate;
//  final int interval;
//  final List<String> times;

  CreateReminder(this.userId);

//  int days = 1;

  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
    TextEditingController days = new TextEditingController();
    days.text = "1";
    name.text = "";

//    List<Widget> buttons = [];
//    if (leftText != null && leftAction != null) {
//      buttons.add(FlatButton(child: new Text(leftText), onPressed: () => leftAction(_alertInput.text)));
//    }
//    if (middleText != null && middleAction != null) {
//      buttons.add(FlatButton(child: new Text(middleText), onPressed: () => middleAction(_alertInput.text)));
//    }
//    if (rightText != null && rightAction != null) {
//      buttons.add(FlatButton(child: new Text(rightText), onPressed: () => rightAction(_alertInput.text)));
//    }

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