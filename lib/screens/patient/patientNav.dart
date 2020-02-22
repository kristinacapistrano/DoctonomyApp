import 'package:doctonomy_app/screens/patient/patientProfile.dart';
import 'package:flutter/material.dart';

import '../sign_in.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../provider/adminNav.dart';
import './patientHome.dart';

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
                icon: const Icon(Icons.home),
                title: new Text('Home'),
              ),
              new BottomNavigationBarItem(
                
                icon: const Icon(Icons.person),
                title: new Text('Profile'),
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
                child: new PatientHome(),
              ),
            ),
            new Offstage(
              offstage: tab != 0,
              child: new TickerMode(
                enabled: tab == 1,
                child: new PatientProfile(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
