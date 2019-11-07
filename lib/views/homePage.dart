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
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home), 
              onPressed: (){print('home icon pressed!');},
              ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: (){print('Calendar icon pressed!');},
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: (){print('Notifications Icon button Pressed!');},
            ),
          ],
          ),
        ),
      //backgroundColor: Color.fromARGB(246, 59, 73, 10),
      body: new Column(
        children: <Widget>[
          //Text('Welcome to the Home Page!'),
          Positioned(
            right: 70.0,
            top: 70.0,
            child: new Image(
              image: new AssetImage("assets/resizedLOGO.jpg"),
              alignment: Alignment.topCenter,
              fit: BoxFit.none,
              color: Colors.red,
              colorBlendMode: BlendMode.dst,
            ),
          ),
        ], //children
      ),
    ); //scaffold is the root for all other elements to be place on the page.
  }
}