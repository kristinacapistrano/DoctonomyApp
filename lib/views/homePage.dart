import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      //backgroundColor: Color.fromARGB(246, 59, 73, 10),
      body: Column(
        children: [
          Text('Welcome to the Home Page!'),
          // Positioned(
          //   right: 70.0,
          //   top: 70.0,
          //   child: new Image(
          //     image: new AssetImage("assets/resizedLOGO.jpg"),
          //     alignment: Alignment.topCenter,
          //     fit: BoxFit.none,
          //     color: Colors.red,
          //     colorBlendMode: BlendMode.dst,
          //   ),
          //)
        RaisedButton(
          child: Text('View Provider Information'),
          onPressed: null
        ),
        RaisedButton(
          child: Text('Important Dates'),
          onPressed: null
          ),
        RaisedButton(
          child: Text('Reminders'),
          onPressed: null,
          )
        ],
      ),
    ); //scaffold is the root for all other elements to be place on the page.
  }
}