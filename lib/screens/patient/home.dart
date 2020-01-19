import 'package:flutter/material.dart';

import '../sign_in.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../widgets/loading.dart';
import '../provider/admin.dart';

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
    } else if (appState.user?.admin == true) {
      return AdminScreen();
    } else {
      if (appState.isLoading) {
        _loadingVisible = true;
      } else {
        _loadingVisible = false;
      }

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

      final userId = appState?.firebaseUserAuth?.uid ?? '';
      final email = appState?.firebaseUserAuth?.email ?? '';

      final userIdLabel = Text('User Id: ');
      final emailLabel = Text('Email: ');

      return Scaffold(
        appBar: AppBar(
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.lightBlueAccent[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
          ),

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
            backgroundColor: Colors.white

        ),

        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () {
                          print('home icon pressed!');
                        }),
                    Text('Home')
                  ]
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          print('Calendar icon pressed!');
                        }),
                    Text('Calendar')
                  ]
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          print('Notifications Icon button Pressed!');
                        }),
                    Text('Notifications')
                  ]
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue[50] ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)
          ),
          child: LoadingScreen(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image(
                          image: new AssetImage("assets/resizedLOGO.jpg"),
                          alignment: Alignment.topCenter,
                          fit: BoxFit.none,
                          color: Colors.red,
                          colorBlendMode: BlendMode.dst,
                        ),
                        SizedBox(height: 48.0),
                        userIdLabel,
                        Text(userId,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 12.0),
                        emailLabel,
                        Text(email,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 12.0),
                        signOutButton
                      ],
                    ),
                  ),
                ),
              ),
              inAsyncCall: _loadingVisible),
        ),
      );
    }
  }
}
