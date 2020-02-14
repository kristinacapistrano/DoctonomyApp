import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/state.dart';
import '../../util/state_widget.dart';
import '../../models/user.dart';

class PatientViewer extends StatefulWidget {
  static const String id = 'patient_viewer';
  final String userId;
  final String title;
  PatientViewer({Key key, @required this.userId, @required this.title}) : super(key: key);

  @override
  _PatientViewerState createState() => _PatientViewerState(userId, title);
}

class _PatientViewerState extends State<PatientViewer> {
  StateModel appState;
  List<User> userList;
  String userId;
  String title;
  _PatientViewerState(this.userId, this.title);

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String,dynamic>> getUserData() async {
    DocumentReference docRef = Firestore.instance.collection('users').document(userId ?? "");
    return docRef.get().then((datasnapshot) async {
      if (datasnapshot.exists) {
        return datasnapshot.data;
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            textTheme: TextTheme(
              title: TextStyle(
                color: Colors.lightBlueAccent[700],
                fontWeight: FontWeight.bold,
              )
            ),
            centerTitle: true,
            title: FittedBox(fit:BoxFit.fitWidth,
                child: Text(title)
            ),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
        body:
          Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: FutureBuilder(
              future: getUserData(),
              builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  print(snapshot.data);
  //                {firstName: Testname2, lastName: Testlastname, allergies: [peanuts], phone: (480) 123-4567}
                    return Center(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text('Upcoming Procedures', style: TextStyle(fontWeight: FontWeight.w500)),
                          //TODO remove hardcoded card
                          Card(child: ListTile(
                            leading: Icon(Icons.healing),
                            title: Text('Surgery'),
                            subtitle: Text('Coming up on 2/20/20'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),

                          SizedBox(height: 20.0),
                          Text('Reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                          //TODO remove hardcoded card
                          Card(child: ListTile(
                            leading: Icon(Icons.alarm),
                            title: Text('Take medication'),
                            subtitle: Text('Every day at 5pm'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),

                          SizedBox(height: 20.0),
                          Text('Allergies', style: TextStyle(fontWeight: FontWeight.w500)),
                          Builder(builder: (BuildContext context) {
                            var allergyList = snapshot.data["allergies"]?.toList() ?? [];
                            if (allergyList.length > 0) {
                              List<Widget> tiles = allergyList.fold(List<Widget>(), (total, el) {
                                total.add(ListTile(title: Text(el, style: TextStyle(fontWeight: FontWeight.w500)), dense: true, onTap: () => {}));
                                total.add(Divider(thickness: 1, indent: 10, endIndent: 10, height: 1));
                                return total;
                              });
                              tiles.add(ListTile(title: Text("+ Add New"), dense: true, onTap: () => {}));
                              return Card(child: Column(children: tiles.toList()));
                            } else {
                              return Card(child: ListTile(
                                title: Text("No Allergies (Click here to add)"),
                                onTap: () {
                                  print("clicked Row");
                                },
                                dense: true
                              )
                              );
                            }
                          }),

                          SizedBox(height: 20.0),
                          Text('Actions', style: TextStyle(fontWeight: FontWeight.w500)),
                          Card(child: ListTile(
                            trailing: Icon(Icons.send),
                            title: Text('Send a message'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),
                          Card(child: ListTile(
                            trailing: Icon(Icons.healing),
                            title: Text('Schedule new procedure'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          ),
                          Card(child: ListTile(
                            trailing: Icon(Icons.clear),
                            title: Text('Remove from my list'),
                            onTap: () {
                              print("clicked Row");
                            },
                          )
                          )
                        ],
                      ),
                    );
                }
              }
            )

          )
    );
  }
}
