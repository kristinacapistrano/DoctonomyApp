import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';
import '../util/auth.dart';
import '../util/state_widget.dart';
import '../util/validator.dart';
import '../widgets/loading.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in_screen';

  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  bool _autoValidate = false;
  bool _loadingVisible = false;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: new Image(
          image: new AssetImage("assets/kids.jpg"),
          alignment: Alignment.center,
          fit: BoxFit.fitHeight,
          ),
    );

    final focus = FocusNode();
    final email = TextFormField(
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
        FocusScope.of(context).requestFocus(focus);
      },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      key: new Key('password'),
      focusNode: focus,
      textInputAction: TextInputAction.done,
      autofocus: false,
      obscureText: true,
      controller: _password,
      validator: Validator.validatePassword,
      style: TextStyle(
        color: Colors.black, //inside box text color
      ),
      onFieldSubmitted: (v){
        focus.unfocus();
        _emailLogin(
            email: _email.text, password: _password.text, context: context);
        },
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.black,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _emailLogin(
              email: _email.text, password: _password.text, context: context);
        },
        padding: EdgeInsets.all(12),
        color: Colors.amber,
        child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        createResetDialog(context).then((onValue){
          String emailAddress = "$onValue";
          if (onValue != null ){
            Auth.sendForgotPasswordEmail(emailAddress);
             createSentEmailDialog();
          }


        });
      },
    );

    final signUpLabel = FlatButton(
      child: Text(
        'Create an Account',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
    );

    return Scaffold(

      backgroundColor: Colors.white,
      body: LoadingScreen(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),

              child: Center(
                child: new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        logo,
                          SizedBox(height: 15.0),
                        email,
                        SizedBox(height: 24.0),
                        password,
                        SizedBox(height: 12.0),
                        loginButton,
                        forgotLabel,
                        signUpLabel,

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _emailLogin(
      {String email, String password, BuildContext context}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        await StateWidget.of(context).logInUser(email, password);
        await Navigator.pushNamed(context, '/');
      } catch (e) {
        _changeLoadingVisible();
        String exception = Auth.getExceptionText(e);
        Flushbar(
          title: "Sign In Error",
          message: exception,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  Future<String> createResetDialog(BuildContext context){
    TextEditingController userController = TextEditingController();
     return showDialog(context: context, builder: (context){
         {
           return AlertDialog(
             title: Text("Email"),
             content: TextField(
               controller: userController,
             ),
             actions: <Widget>[
               MaterialButton(
                 elevation: 5.0,
                 child: Text('Reset password'),
                 onPressed: (){
                   Navigator.of(context).pop(userController.text.toString());

                 },
               )
             ],
           );
         }});
    }
  Future createSentEmailDialog(){
    TextEditingController userController = TextEditingController();
    return showDialog(context: context, builder: (context){
      {
        return AlertDialog(
          title: Text("Reset email sent"),
          actions: <Widget>[

          ],
        );
      }});
  }
  }
