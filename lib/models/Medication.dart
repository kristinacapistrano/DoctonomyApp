import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Medication userFromJson(String str) {
  final jsonData = json.decode(str);
  return Medication.fromJson(jsonData);
}

String userToJson(Medication data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Medication {
  String name;
  String consumptionMethod;
  String frequency;
  List usage = new List();
  

  Medication({
    this.name,
    this.consumptionMethod,
    this.frequency,
    this.usage,
  });

  factory Medication.fromJson(Map<String, dynamic>json) => new Medication(
      name: json['name'],
      consumptionMethod: json['consumptionMethod'],
      frequency: json['frequency'],
      usage: json['usage'],
  );
    
  Map<String, dynamic> toJson() => {
    "name": name,
    "consumptionMethod": consumptionMethod,
    "frequency": frequency,
    "usage": usage,
  };

  factory Medication.fromDocument(DocumentSnapshot doc) {
    return Medication.fromJson(doc.data);
  }

  String get medName {
    return name;
  }

  String get method {
    return consumptionMethod;
  }

  String get freq {
    return frequency;
  }

  List get uses {
    return usage;
  }
}