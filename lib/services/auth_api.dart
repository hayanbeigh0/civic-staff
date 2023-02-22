import 'dart:convert';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:http/http.dart' as http;


class Auth_Api {
 Future<Map> signIn(String phoneNumber)async{
    var url = Uri.parse("$API_URL/cognito/sign-in");
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
        "phone_number": phoneNumber,
        "user_type": "STAFF"
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return json.decode(response.body);
    }

  }

 Future<Map> verifyOtp(Map<String, dynamic> userDetails, String otp)async{
    var url = Uri.parse("$API_URL/cognito/verify");
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
        "username": userDetails['username'],
        "session": userDetails['session'],
        "answer": otp
    });

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return json.decode(response.body);
    }
  }
}