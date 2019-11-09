import 'package:flutter/material.dart';

import './screens/home.dart';
import './screens/sign_in.dart';
import './util/state_widget.dart';

void main() {
  StateWidget stateWidget = new StateWidget(
    child: new MyApp(),
  );
  runApp(stateWidget);
}

class MyApp extends StatelessWidget {
  // This widget is the roost of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.red),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SignInScreen.id: (context) => SignInScreen(),
      },
    );
  }
}
