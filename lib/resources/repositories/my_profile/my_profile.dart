import 'dart:convert';

import 'package:civic_staff/models/my_profile.dart';
import 'package:flutter/services.dart';

class MyProfileRerpository {
  late MyProfile myProfile;
  Future<String> getMyProfileJson() async {
    return rootBundle.loadString('assets/my_profile.json');
  }

  Future<MyProfile> loadMyProfileJson() async {
    await Future.delayed(const Duration(seconds: 2));
    myProfile = MyProfile.fromJson(json.decode(await getMyProfileJson()));
    return myProfile;
  }
}
