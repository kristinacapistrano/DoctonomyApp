class Medication {
  String name;
  String consumptionMethod;
  String frequency;
  List usage = new List();
  

  Medication(name){
    this.name = name;
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