import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository {
  // static List<User> usersList = [];
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
    List<User> usersList = list.map((e) => User.fromJson(e)).toList();
    log('User loaded');
    return usersList;
  }

  Future<List<User>> getUser() async {
    log('User list fetched!');
    return await loadUserJson();
  }

  Future<Response> getUserByFilter(Map<String, dynamic> filter) async {
    const String url = '$API_URL/user/by-filter';
    final response = await Dio().get(
      url,
      data: jsonEncode(filter),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  Future<Response> getAllUsers() async {
    const String url = '$API_URL/user/all-users';
    final response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  Future<Response> getUserById(String userId) async {
    const String url = '$API_URL/user/by-user-id';
    final response = await Dio().get(
      url,
      data: jsonEncode({"userId": userId}),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  Future<Response> addUser(User user) async {
    final response = Dio().post(
      '$API_URL/staff/create-user',
      data: jsonEncode({
        "about": user.about,
        "active": user.active,
        "address": user.address,
        "countryCode": user.countryCode,
        "staffId": user.staffId,
        "createdDate": user.createdDate,
        "emailId": user.emailId,
        "firstName": user.firstName,
        "lastModifiedDate": user.lastModifiedDate,
        "lastName": user.lastName,
        "mobileNumber": user.mobileNumber,
        "municipalityId": user.municipalityId,
        "notificationToken": user.notificationToken,
        "profilePicture": user.profilePicture,
        "latitude": user.latitude,
        "longitude": user.longitude,
        "wardNumber": user.wardNumber
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  Future<dynamic> editUser(User user) async {
    log(user.userId.toString());
    final response = Dio().put(
      '$API_URL/user/modify-user',
      data: jsonEncode({
        "userId": user.userId,
        "about": user.about,
        "active": user.active,
        "address": user.address,
        "countryCode": user.countryCode,
        "staffId": user.staffId,
        "createdDate": user.createdDate,
        "emailId": user.emailId,
        "firstName": user.firstName,
        "lastModifiedDate": user.lastModifiedDate,
        "lastName": user.lastName,
        "mobileNumber": user.mobileNumber,
        "municipalityId": user.municipalityId,
        "notificationToken": user.notificationToken,
        "profilePicture": user.profilePicture,
        "latitude": user.latitude,
        "longitude": user.longitude,
        "wardNumber": user.wardNumber
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;

    User newUser = user;
    newUser.about = user.about;
    newUser.mobileNumber = user.mobileNumber;
    newUser.emailId = user.emailId;
    newUser.latitude = user.latitude;
    newUser.longitude = user.longitude;
    newUser.address = user.address;
    newUser.wardNumber = user.wardNumber;
    newUser.firstName = user.firstName;
    newUser.lastName = user.lastName;
    newUser.active = true;
    newUser.countryCode = '+91';
    newUser.municipalityId = "";
  }

  // Future<void> deleteUser(User user) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   usersList.removeWhere(
  //     (element) => element.id == user.id,
  //   );
  // }
}
