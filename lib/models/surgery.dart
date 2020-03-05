import 'package:doctonomy_app/models/provider.dart';

class Surgery {
  String name;
  String type;
  String description;
  
  Surgery({name, type, teamSize}){
    this.name = name;
    this.type = type;
  }

  Map <String, dynamic> toJson() {
    return {
    "name": name,
    "description": description
    };
  }
  String getName(){
    return name;
  }

  void setDescription(String desc){
    this.description = desc;
  }

  void setName(String newName){
    this.name = newName;
  }

  String getType(){
    return type;
  }

  void setType(String newType){
    this.type = newType;
  }
}