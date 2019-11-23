import 'package:doctonomy_app/models/provider.dart';

class Surgery {
  String name;
  String type;
  List <Provider> performedBy;
  
  Surgery({name, type, teamSize}){
    this.name = name;
    this.type = type;
    performedBy = new List(teamSize);
  }

  void add(Provider provider){
    performedBy.add(provider);
  }

  void remove(Provider provider){
    int index;
    for (int i = 0; i < performedBy.length; i++){
      if (performedBy[i].firstName == provider.firstName && performedBy[i].lastName == provider.lastName){
        index = i;
      }
    }
    if(index != null){
      performedBy.removeAt(index);
    }
  }
}