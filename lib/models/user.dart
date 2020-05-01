import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String userId;
  String firstName;
  String lastName;
  String email;
  bool admin;
  String phone;
  List<dynamic> devTokens;

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.admin,
    this.phone,
    this.devTokens = const ['', ''],
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        admin: json["admin"] ?? false,
        phone: json["phone"],
        devTokens: json["dev-tokens"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "admin": admin,
        "phone": phone,
        'dev-tokens': devTokens,
      };

  factory User.fromDocument(DocumentSnapshot doc) {
    return User.fromJson(doc.data);
  }

  String get id {
    return userId;
  }

  String get name {
    return firstName + lastName;
  }

  String get emailAddress {
    return email;
  }
}
