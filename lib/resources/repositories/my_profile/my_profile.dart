import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:dio/dio.dart';

class MyProfileRerpository {
  // late MyProfile myProfile;
  getMyProfileJson(String staffId) async {
    log('getting staff profile');
    const String url = '$API_URL/staff/by-staff-id';
    final response = await Dio().get(
      url,
      data: jsonEncode({"staffId": staffId}),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    log('Repository response: $response');
    return response;
  }

  editProfile(UserDetails userDetails) async {
    log('getting staff profile');
    const String url = '$API_URL/staff/modify-staff-member';
    final response = await Dio().put(
      url,
      data: jsonEncode({
        "staffId": userDetails.staffID,
        "active": userDetails.active,
        "createdBy": userDetails.createdBy,
        "createdDate": "2023-02-09 18:40:41",
        "email": userDetails.emailID,
        "firstName": userDetails.firstName,
        "lastModifiedDate": "2023-02-09 18:40:41",
        "lastName": userDetails.lastName,
        "mobile": userDetails.mobileNumber,
        "municipalityId": userDetails.municipalityID,
        "notificationToken": userDetails.notificationToken,
        "profilePicture": userDetails.profilePicture,
        "role": userDetails.role
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  // Future<MyProfile> loadMyProfileJson(String staffId) async {
  //   MyProfile myProfile =
  //       MyProfile.fromJson(json.decode(await getMyProfileJson(staffId)));
  //   return myProfile;
  // }
}
