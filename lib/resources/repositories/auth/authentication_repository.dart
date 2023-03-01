import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:dio/dio.dart';

class AuthenticationRepository {
  signIn(String phoneNumber) async {
    var url = "$API_URL/cognito/sign-in";
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({"phone_number": phoneNumber, "user_type": "STAFF"});

    var response = await Dio().post(
      url,
      options: Options(
        headers: headers,
      ),
      data: body,
    );
    // log('Response: ${json.decode(response.data)} ${response.statusCode}');
    return response;
  }

  verifyOtp(Map<String, dynamic> userDetails, String otp) async {
    var url = "$API_URL/cognito/verify";
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      "username": userDetails['username'],
      "session": userDetails['session'],
      "phone_number": userDetails['phone_number'],
      "user_type": userDetails['user_type'],
      "answer": otp
    });
    // log(body);

    var response = await Dio().post(
      url,
      options: Options(
        headers: headers,
      ),
      data: body,
    );
    return response;
  }
}
