import 'package:flutter/material.dart';

import '../sign_in.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../patient/patientNav.dart';
import './adminHome.dart';
import './adminPatients.dart';

class AdminNav extends StatefulWidget {
  static const String id = 'admin_nav';

  _AdminNavState createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
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
    } else if (appState.user?.admin != true) {
      return PatientNav();
    } else {
      return Scaffold(
        bottomNavigationBar: new BottomNavigationBar(
            currentIndex: tab,
            onTap: (int index) {
              print('Admin Tab: ' + index.toString());
              setState(() {
                tab = index;
              });
              //_navigateToScreens(index);
            },
            items: [
              new BottomNavigationBarItem(
                icon: const Icon(Icons.people),
                title: new Text('Patients'),
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
            new Offstage(
              offstage: tab != 0,
              child: new TickerMode(
                enabled: tab == 0,
                child: new AdminPatients(),
              ),
            ),
            new Offstage(
              offstage: tab != 1,
              child: new TickerMode(
                enabled: tab == 1,
                child: new AdminHome(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
