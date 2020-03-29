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
  List <String> _criteria = ['a', 'b', 'c', 'd'];
  List <String> _criteria2 = ['1', '2', '3', '4'];
  // List<String> _allergies;
  // List<String> _procedures;
  // List<String> _medications;
  String _selectedCriteria1;
  String _selectedCriteria2;

  _PatientFilterState(this.myUsers);

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 8;
    final double itemWidth = size.width / 2;
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50, // constrain height
              child: GridView.count(
                primary: false,
                crossAxisSpacing: 0.0,
                crossAxisCount: 2,
                children: <Widget>[
                  DropdownButton(
                    isExpanded: true,
                    hint: Text("Please choose criteria to filter by"),
                    value: _selectedCriteria1,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCriteria1 = newValue;
                      });
                    },
                    items: _criteria.map((criteria){
                      return DropdownMenuItem(
                        child: new Text(criteria),
                        value: criteria,
                      );
                    }).toList(),
                  ),
                  DropdownButton(
                    isExpanded: true,
                    hint: Text("Please choose criteria 2 to filter by"),
                    value: _selectedCriteria2,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCriteria2 = newValue;
                      });
                    },
                    items: _criteria.map((criteria2){
                      return DropdownMenuItem(
                        child: new Text(criteria2),
                        value: criteria2,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Text("The rest of the content can go below these dropdowns")
          ]
        )
      )
    );
  }
}