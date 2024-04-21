// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AuthStatus {
  initial,
  authorized,
  unauthorized,
  error_of_password,
  user_not_found,
  network_failure,
  user_exist,
  unknown
}

class UserData {
  int id = -1;
  String username = '';
  String password = '';
  String email = '';
  String first_name = '';
  String last_name = '';
  DateTime date_birth = DateTime.now();
  String accessToken = '';
  AuthStatus authStatus = AuthStatus.unauthorized;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'date_birth': date_birth.toString()
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserData(id: $id, username: $username, password: $password, email: $email, first_name: $first_name, last_name: $last_name, accessToken: $accessToken, authStatus: $authStatus)';
  }
}

Future<void> setUserData(UserData user) async {
  await Hive.initFlutter();
  Box box = await Hive.openBox('UserBox');
  box.put('id', user.id);
  box.put('username', user.username);
  box.put('email', user.email);
  box.put('first_name', user.first_name);
  box.put('last_name', user.last_name);
  box.put('date_birth', user.date_birth.millisecondsSinceEpoch);
  box.put('password', user.password);
  box.put('accessToken', user.accessToken);
}

Future<void> deleteUserData() async {
  await Hive.initFlutter();
  Box box = await Hive.openBox('UserBox');
  box.put('id', '');
  box.put('username', '');
  box.put('email', '');
  box.put('first_name', '');
  box.put('last_name', '');
  box.put('date_birth', '');
  box.put('password', '');
  box.put('accessToken', '');
}

Future<UserData> getUserData() async {
  await Hive.initFlutter();
  UserData user = UserData();
  Box box = await Hive.openBox('UserBox');
  user.id = box.get('id');
  user.username = box.get('username');
  user.email = box.get('email');
  user.first_name = box.get('first_name');
  user.last_name = box.get('last_name');
  user.date_birth =
      DateTime.fromMillisecondsSinceEpoch(box.get('date_birth') * 1000);
  user.password = box.get('password');
  user.accessToken = box.get('accessToken');
  return user;
}
