import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctonomy_app/screens/sign_in.dart';

void main() {
  testWidgets('Test Form Empty Validation', (WidgetTester tester) async {
    //Tests that the form validation fails when textfields are empty
    SignInScreen sis = new SignInScreen();
    var app = new MediaQuery(data: new MediaQueryData(), child: new MaterialApp(home: sis));
    await tester.pumpWidget(app);
    Finder formWidgetFinder = find.byType(Form);
    Form formWidget = tester.widget(formWidgetFinder) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;
    expect(formKey.currentState.validate(), isFalse);
  });

  testWidgets('Test Form Filled Validation', (WidgetTester tester) async {
    //Sets up a test environment "app" on the SignInScreen widget
    SignInScreen sis = new SignInScreen();
    var app = new MediaQuery(data: new MediaQueryData(), child: new MaterialApp(home: sis));
    await tester.pumpWidget(app);

    //Finds the email and password textfields by key
    Finder email = find.byKey(new Key('email'));
    Finder pwd = find.byKey(new Key('password'));

    //Fills in the text on the email and password textfields
    await tester.enterText(email, "test@email.com");
    await tester.enterText(pwd, "test123");
    await tester.pump();

    //Finds the form widget
    Finder formWidgetFinder = find.byType(Form);
    Form formWidget = tester.widget(formWidgetFinder) as Form;
    GlobalKey<FormState> formKey = formWidget.key as GlobalKey<FormState>;

    //Asserts that the form is in a valid state
    expect(formKey.currentState.validate(), isTrue);
  });

  testWidgets('Login unit test', (WidgetTester tester) async {
    //Tests the login functionality with the test login account
    SignInScreen sis = new SignInScreen();
    var app = new MediaQuery(data: new MediaQueryData(), child: new MaterialApp(home: sis));
    await tester.pumpWidget(app);
    Finder email = find.byKey(new Key('email'));
    Finder pwd = find.byKey(new Key('password'));

    //TODO simulate login API, check for a successful response
  });
}
