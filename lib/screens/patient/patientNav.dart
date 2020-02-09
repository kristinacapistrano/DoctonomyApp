import 'package:flutter/material.dart';

import './patientHome.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../provider/adminNav.dart';
import '../sign_in.dart';

class PatientNav extends StatefulWidget {
  static const String id = 'patient_nav';

  _PatientNavState createState() => _PatientNavState();
}

class _PatientNavState extends State<PatientNav> {
  StateModel appState;
  int tab = 1;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    if (!appState.isLoading &&
        (appState.firebaseUserAuth == null || appState.user == null
        // || appState.settings == null
        )) {
      return SignInScreen();
    } else if (appState.user?.admin == true) {
      return AdminNav();
    } else {
      return Scaffold(
        appBar: AppBar(
            textTheme: TextTheme(
                title: TextStyle(
              color: Colors.lightBlueAccent[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Home Page"),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Image.asset('assets/appbar_logo.png'),
                iconSize: 100.0,
                highlightColor: Colors.red,
                onPressed: () {
                  print('Click PCH');
                },
              ),
            ],
            backgroundColor: Colors.white),
        bottomNavigationBar: new BottomNavigationBar(
            currentIndex: tab,
            onTap: (int index) {
              print('Patient Tab: ' + index.toString());
              setState(() {
                tab = index;
              });
              //_navigateToScreens(index);
            },
            items: [
              new BottomNavigationBarItem(
                icon: const Icon(Icons.star),
                title: new Text('TODO'),
              ),
              new BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                title: new Text('Home'),
              ),
              new BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                title: new Text('Options'),
              )
            ]),
        body: new Stack(
          children: <Widget>[
//            new Offstage(
//              offstage: tab != 0,
//              child: new TickerMode(
//                enabled: tab == 0,
//                child: new MaterialApp(home: new YourLeftPage()),
//              ),
//            ),
            new Offstage(
              offstage: tab != 1,
              child: new TickerMode(
                enabled: tab == 1,
                child: new PatientHome(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
