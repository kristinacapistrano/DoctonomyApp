

import 'package:doctonomy_app/models/user.dart';

class Provider extends User {
  bool isAdmin;
  
  Provider () : super();

  bool setAdmin(){
    return isAdmin = true;
  }

  bool revokeAdmin () {
    return isAdmin = false;
  }
}