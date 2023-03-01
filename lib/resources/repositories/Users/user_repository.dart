import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository {
  static List<User> usersList = [];
  Future<String> getUserJson() async {
    final response = await Dio().get(
      '$API_URL/user/all-users',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return jsonEncode(response.data);
  }

  Future<List<User>> loadUserJson() async {
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
    try {
      Dio().post(
        '$API_URL/staff/create-user',
        data: user,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      if (e is DioError) {
        if (e.response!.statusCode == 404) {
          log('${e.response!.statusCode}');
        } else {
          log('${e.message}');
        }
      } else {
        log('$e');
      }
    }
  }

  Future<void> editUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));

    // User newUser = usersList.firstWhere((element) => element.id == user.id);
    // newUser.about = user.about;
    // newUser.mobileNumber = user.mobileNumber;
    // newUser.emailId = user.emailId;
    // newUser.latitude = user.latitude;
    // newUser.longitude = user.longitude;
    // newUser.address = user.address;
    // newUser.wardNumber = user.wardNumber;
    // newUser.firstName = user.firstName;
    // newUser.lastName = user.lastName;
    // newUser.active = true;
    // newUser.countryCode = '+91';
    // newUser.municipalityId =
  }

  // Future<void> deleteUser(User user) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   usersList.removeWhere(
  //     (element) => element.id == user.id,
  //   );
  // }
}
