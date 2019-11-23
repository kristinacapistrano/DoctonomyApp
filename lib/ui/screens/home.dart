import 'package:doctonomy_app/widgets/mesaging.dart';
import 'package:flutter/material.dart';

import './sign_in.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  bool _loadingVisible = false;

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
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }
      final logo = Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60.0,
            child: ClipOval(
              child: Image.asset(
                'assets/images/default.png',
                fit: BoxFit.cover,
                width: 120.0,
                height: 120.0,
              ),
            )),
      );

      final signOutButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            StateWidget.of(context).logOutUser();
          },
          padding: EdgeInsets.all(12),
          color: Theme.of(context).primaryColor,
          child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
        ),
      );


//check for null https://stackoverflow.com/questions/49775261/check-null-in-ternary-operation
      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';

      final userIdLabel = Text('User Id: ');
      final emailLabel = Text('Email: ');

      return Scaffold(
        backgroundColor: Colors.white,
        body:
              LoadingScreen(

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MessagingWidget(),
                          SizedBox(height: 48.0),
                          userIdLabel,
                          Text(userId,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 12.0),
                          emailLabel,
                          Text(email,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 12.0),
                          signOutButton,

                        ],
                      ),
                    ),
                  ),
                ),
                  inAsyncCall: _loadingVisible)

        );

    }
  }
}
