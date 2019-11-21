import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctonomy_app/screens/sign_in.dart';
import 'package:doctonomy_app/models/user.dart';

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

    //Note: Actual login method cannot be Unit Tested, since tests don't run on devices, but only the devices have the Firebase framework
  });

  testWidgets('Test Constructors', (WidgetTester tester) async {
    User user = userFromJson('{"userId": "fakeID", "firstName": "testFirst", "lastName": "testLast", "email": "testEmail", "admin": false, "phone": "4801234567"}');
    expect(user != null, true);
    expect(user.userId, "fakeID");
    expect(user.firstName, "testFirst");
    expect(user.lastName, "testLast");
    expect(user.email, "testEmail");
    expect(user.admin, false);
    expect(user.phone, "4801234567");
  });
}
