import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/models/user_model.dart';
import 'package:flutter/services.dart';

class UserRepository {
  static List<User> usersList = [];
  Future<String> getUserJson() async {
    return rootBundle.loadString('assets/users.json');
  }

  Future<List<User>> loadUserJson() async {
    await Future.delayed(const Duration(seconds: 2));
    final list = json.decode(await getUserJson()) as List<dynamic>;
    usersList = list.map((e) => User.fromJson(e)).toList();
    log('User loaded');
    return usersList;
  }

  Future<List<User>> getUser() async {
    await Future.delayed(const Duration(seconds: 2));
    log('User list fetched!');
    return usersList;
  }

  Future<void> addUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));

    usersList.add(user);
  }

  Future<void> editUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));

    User newUser = usersList.firstWhere((element) => element.id == user.id);
    newUser.about = user.about;
    newUser.city = user.city;
    newUser.country = user.country;
    newUser.email = user.email;
    newUser.mobileNumber = user.mobileNumber;
    newUser.email = user.email;
    newUser.latitude = user.latitude;
    newUser.longitude = user.longitude;
    newUser.streetName = user.streetName;
    newUser.wardNumber = user.wardNumber;
    newUser.firstName = user.firstName;
    newUser.lastName = user.lastName;
  }

  Future<void> deleteUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));
    usersList.removeWhere(
      (element) => element.id == user.id,
    );
  }
}
