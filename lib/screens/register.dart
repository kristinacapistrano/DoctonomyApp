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
  final focus = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  bool _autoValidate = false;

  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pswd = new TextEditingController();
  final TextEditingController _pswd2 = new TextEditingController();

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
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
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    key: new Key('firstname'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: _fname,
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
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus);
                    },
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('lastname'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: _lname,
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
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus2);
                    },
                    focusNode: focus,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
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
                    controller: _email,
                    validator: Validator.validateEmail,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus3);
                    },
                    focusNode: focus2,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('password'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: _pswd,
                    validator: (String value) {
                      if (value.trim().length < 6) {
                        return 'Password must be 6 or more characters';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onFieldSubmitted: (v){
                      FocusScope.of(context).requestFocus(focus4);
                    },
                    focusNode: focus3,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    key: new Key('confirm password'),
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: _pswd2,
                    validator: (String value) {
                      if (value != _pswd.text || value.trim().isEmpty) {
                        return 'Passwords do not match';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    onFieldSubmitted: (v){
                      focus4.unfocus();
                      _submit();
                    },
                    focusNode: focus4,
                    decoration: InputDecoration(
                      labelText: 'Confirm Passwords',
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
                      _submit();
                    },
                    padding: EdgeInsets.all(12),
                    color: Colors.amber,
                    child: Text('Register', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )));
  }

  void _submit() {
    if (_formKey.currentState.validate()) {
      globalKey.currentState.showSnackBar(const SnackBar(
        content: Text('Create Account Successfully (placeholder)'),
      ));
    } else {
      setState(() => _autoValidate = true);
    }
  }
}
