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
    log('User added');
    log('User list length after adding a User: ${usersList.length}');
  }

  Future<void> deleteUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));
    usersList.removeWhere(
      (element) => element.id == user.id,
    );
  }
}
