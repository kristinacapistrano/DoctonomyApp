import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import 'package:flutter/cupertino.dart';

import 'package:doctonomy_app/screens/provider/patientViewer.dart';

class ReminderDateTimePicker extends StatefulWidget{
  static const String id = 'create_reminderDateTime';

  _ReminderDateTimePicker createState() => _ReminderDateTimePicker();
}

class _ReminderDateTimePicker extends State {

  DateTime _datetime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                child: Text('Schedule for Reminder')
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
      body:Column(
        children: <Widget>[

          SizedBox(
            height: 500.0,
            child: CupertinoDatePicker(
              initialDateTime: _datetime,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    setState(() {
                      print(dateTime);
                      _datetime = dateTime;
                    });
                  });
                },
            ),
          ),
          RaisedButton(
            child: Text('Set'),
            onPressed: () {
              showDialog(context: context,
              builder: (_) => AlertDialog(
                title: Text('Schedule you selected'),
                content: Text('${_datetime.day}/${_datetime.month}/${_datetime.year}\n'
                    '${_datetime.hour}:${_datetime.minute}')
              ));
            }
          )
        ],
      )
    );
  }
}