import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

class PatientFilter extends StatefulWidget {
  static const String id = 'patient_filter';
  List<dynamic> myUsers;
  PatientFilter({Key key, @required this.myUsers}) : super(key: key);

  @override
  _PatientFilterState createState() => _PatientFilterState(myUsers);
}

class _PatientFilterState extends State<PatientFilter> {
  StateModel appState;
  List<User> userList;
  List<dynamic> myUsers;

  _PatientFilterState(this.myUsers);

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.lightBlueAccent[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
          title: Text("Filter Patients"),
          iconTheme: IconThemeData(
            color: Colors.lightBlueAccent[700],
          ),
          backgroundColor: Colors.white,
      ),
    );
  }
}