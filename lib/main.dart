import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new LoginPage(),
      theme: new ThemeData(
        primarySwatch: Colors.red
      ),

    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color.fromRGBO(246, 59, 73, 10),
      body: new Stack(
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/PCH_LOGO.jpg"),
            fit:  BoxFit.cover,
            color: Colors.red,
            colorBlendMode: BlendMode.dst
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                child: Theme(
                  data: new ThemeData(
                    brightness: Brightness.light,primarySwatch: Colors.amber,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Colors.amber
                      )
                    )
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(50.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                            hintText: "Enter Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(
                            hintText: "Enter Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
