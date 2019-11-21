import 'package:doctonomy_app/models/user.dart';

class Patient extends User {
  var medications = new List();
  var surgeries = new List();


  Patient(this.medications, this.surgeries) : super();

  List get medHistory {
    return medications;
  }

  List get surgeryHistory {
    return surgeries;
  }
}