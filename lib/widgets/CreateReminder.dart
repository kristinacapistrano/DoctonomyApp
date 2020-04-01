import 'package:flutter/material.dart';

class CreateReminder extends AlertDialog {
  final String userId;
//  final String name;
//  final String startDate;
//  final String endDate;
//  final int interval;
//  final List<String> times;

  CreateReminder(this.userId);

  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
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
            TextField(
              controller: name,
              decoration: new InputDecoration(
                hintText: 'Every _ days',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            )
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