import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctonomy_app/models/provider.dart';

class Surgery {
  String name;
  String type;
  List <Provider> performedBy;
  
  Surgery({
    this.name, 
    this.type, 
    this.performedBy,
    });

  factory Surgery.fromJson(Map<String, dynamic>json) => new Surgery(
      name: json['name'],
      type: json['type'],
      performedBy:  json['performedBy'],
  );

  Map<String, dynamic> toJson()=> {
    "name" : name,
    "type" : type,
    "performedBy" : performedBy,
  };

  factory Surgery.fromDocument(DocumentSnapshot doc) {
    return Surgery.fromJson(doc.data);
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