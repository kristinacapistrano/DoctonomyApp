class Medication {
  String name;
  String consumptionMethod;
  String frequency;
  List usage = new List();
  

  Medication(name){
    this.name = name;
  }

  Medication.fromJson(Map<String, dynamic>json) :
    name = json['name'],
    consumptionMethod = json['consumptionMethod'],
    frequency = json['frequency'],
    usage = json['usage'];


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