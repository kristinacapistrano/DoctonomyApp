import 'package:flutter/material.dart';
import './widgets/Hyperlink.dart';

import './util/state_widget.dart';
//import 'package:flutter_firebase_auth_example/ui/theme.dart';
import './ui/screens/home.dart';
import './ui/screens/sign_in.dart';
//import 'package:flutter_firebase_auth_example/ui/screens/sign_up.dart';
//import 'package:flutter_firebase_auth_example/ui/screens/forgot_password.dart';


//void main() => runApp(MyApp());

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
      //home: new LoginPage(),
      theme: new ThemeData(
        primarySwatch: Colors.red
      ),
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignInScreen(),
        //'/signup': (context) => SignUpScreen(),
        //'/forgot-password': (context) => ForgotPasswordScreen(),
      },

    );
  }
}
