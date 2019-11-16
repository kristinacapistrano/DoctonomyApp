import 'package:doctonomy_app/models/user.dart';

class Patient extends User {
  String illness = '';
  var medications = new List();
  var surgeries = new List();


  Patient(this.illness, this.medications, this.surgeries) : super();
}