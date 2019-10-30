import 'package:flutter/material.dart';
import './widgets/Hyperlink.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the roost of your application.
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
      body: new Stack (
        children: <Widget>[
          Positioned(
            right: 70.0,
            top: 70.0,
            child: new Image(

                image: new AssetImage("assets/resizedLOGO.jpg"),
                alignment: Alignment.topCenter,
                fit:  BoxFit.none,
                color: Colors.red,
                colorBlendMode: BlendMode.dst//dst
            ),
          ),

          Positioned(
            right: 210.0,
            bottom: 80.0,
            child: Hyperlink('https://www.phoenixchildrens.org/about-us', 'About Us |'),
          ),
          Positioned(
            right: 160.0,
            bottom: 80.0,
            child: Hyperlink('https://www.phoenixchildrens.org/contact', 'Contact'),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Form(
                child: Theme(
                  data: new ThemeData(
                    brightness: Brightness.dark,primarySwatch: Colors.red,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0
                      )
                    )
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(50.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Color(0xFFFFDFDFDF)),
                        left: BorderSide(width: 2.0, color: Color(0xFFFFDFDFDF)),
                        right: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                        bottom: BorderSide(width: 2.0, color: Color(0xFFFF7F7F7F)),
                      ),
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Enter Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Enter Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(
                            padding: const EdgeInsets.only(top: 20.0)
                        ),
                        new MaterialButton(
                            color: Colors.amber,
                            textColor: Colors.white,
                            child: new Text("LOGIN"),

                            onPressed: ()=>{}  //insert action for the button
                            )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),


        ],
      ),
    );
  }
}
