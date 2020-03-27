import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ReminderDateTimePicker extends StatefulWidget{
  static const String id = 'create_reminderDateTime';

  final String userId;
  final String title;
  ReminderDateTimePicker({Key key, @required this.userId, @required this.title}) :super(key: key);
  @override
  _ReminderDateTimePicker createState() => _ReminderDateTimePicker(userId, title);

}

class _ReminderDateTimePicker extends State {
  StateModel appState;
  String schedule, time ;
  String userId;
  String title;
  _ReminderDateTimePicker(this.userId, this.title);
  DateTime _datetime = DateTime.now();

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
                child: Text('Schedule for Reminder')
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
      body:FutureBuilder(
        future: getUserData(), builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          print(snapshot.data);
          return Column(
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
                        schedule = new DateFormat.yMMMd().format(_datetime);

                      });
                    });
                  },
                ),
              ),
              RaisedButton(
                  child: Text('Set'),
                  onPressed: () {
                    showDialog(context: context,
                        builder: (_) =>
                            AlertDialog(
                              title: Text('Schedule you selected'),
                              content: Text(schedule),


                            ));
                  }
              )
            ],
          );
        }
      })
    );
  }
}