import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotiWidget extends StatefulWidget{
  _LocalNotiWidgetState createState() => _LocalNotiWidgetState();

}
class _LocalNotiWidgetState extends State<LocalNotiWidget>{
  void initState(){
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var settingsIOS = IOSInitializationSettings(
      //onDidReceiveLocalNotification: (id, title,body, payload)=>
          //onSelectNotification(payload)
    );
  }

  Widget build(BuildContext context) =>Container();
}