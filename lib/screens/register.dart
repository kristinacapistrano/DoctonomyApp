import 'package:doctonomy_app/util/validator.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register';

  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.light,
            textTheme: TextTheme(
                title: TextStyle(
              color: Colors.lightBlueAccent[700],
              fontWeight: FontWeight.bold,
            )),
            centerTitle: true,
            title: FittedBox(fit: BoxFit.fitWidth, child: Text("Register")),
            iconTheme: IconThemeData(color: Colors.lightBlueAccent[700]),
            backgroundColor: Colors.white),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    key: new Key('firstname'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
//                    controller: _email,
//                    validator: Validator.validateEmail,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'First name is required';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
//                    onFieldSubmitted: (v){
//                      FocusScope.of(context).requestFocus(focus);
//                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      hintText: 'First Name',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('lastname'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
//                    controller: _email,
//                    validator: Validator.validateEmail,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Last name is required';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
//                    onFieldSubmitted: (v){
//                      FocusScope.of(context).requestFocus(focus);
//                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      hintText: 'Last Name',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
//                    controller: _email,
//                    validator: Validator.validateEmail,
                    validator: Validator.validateEmail,
                    style: TextStyle(
                      color: Colors.black,
                    ),
//                    onFieldSubmitted: (v){
//                      FocusScope.of(context).requestFocus(focus);
//                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      hintText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('password'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
//                    controller: _email,
//                    validator: Validator.validateEmail,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Password is required';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
//                    onFieldSubmitted: (v){
//                      FocusScope.of(context).requestFocus(focus);
//                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      hintText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('confirm password'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
//                    controller: _email,
//                    validator: Validator.validateEmail,
                    validator: (String value) {
                      if (value.trim().isEmpty) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
//                    onFieldSubmitted: (v){
//                      FocusScope.of(context).requestFocus(focus);
//                    },
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                      hintText: 'Confirm Passwords',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    onPressed: () {
//                        _emailLogin(
//                            email: _email.text, password: _password.text, context: context);
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.amber,
                    child: Text('Register', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )));
  }

  bool _submittable() {
    return true;
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      const SnackBar snackBar = SnackBar(content: Text('Form submitted'));

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
