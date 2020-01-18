import 'package:doctonomy_app/models/user.dart';

class Patient extends User {
  var medications = new List();
  var surgeries = new List();
  var allergies = new List();
  bool responsibleParty;


  Patient(this.medications, this.surgeries, this.allergies) : super();

  List get medHistory {
    return medications;
  }

  List get surgeryHistory {
    return surgeries;
  }

  List get allergiesHistory{
    return allergies;
  }

  bool isReponsibleParty(){
    return responsibleParty = false; //true if patient is 18
  }


}