import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/my_profile.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/resources/repositories/my_profile/my_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final MyProfileRerpository myProfileRerpository;
  MyProfileCubit(this.myProfileRerpository) : super(MyProfileLoading());
  // loadMyProfile() async {
  //   emit(MyProfileLoaded(
  //     myProfile: myProfileRerpository.myProfile,
  //   ));
  // }

  getMyProfile(String staffId) async {
    emit(MyProfileLoading());
    final response = await myProfileRerpository.getMyProfileJson(staffId);
    UserDetails userDetails =
        UserDetails.fromJson(jsonDecode(response.toString()));
    AuthBasedRouting.afterLogin.userDetails = userDetails;
    emit(MyProfileLoaded(
      myProfile: MyProfile(
        about: '',
        allocatedWards: [],
        city: '',
        country: '',
        email: userDetails.emailID,
        firstName: userDetails.firstName,
        id: userDetails.staffID,
        lastName: userDetails.lastName,
        latitude: '',
        longitude: '',
        mobileNumber: userDetails.mobileNumber,
        muncipality: userDetails.municipalityID,
        streetName: '',
      ),
      userDetails: userDetails,
    ));
  }

  editMyProfile(MyProfile myProfile) {
    final userDetails = UserDetails(
        active: true,
        emailID: myProfile.email,
        firstName: myProfile.firstName,
        lastName: myProfile.lastName,
        mobileNumber: myProfile.mobileNumber,
        municipalityID: myProfile.muncipality,
        staffID: myProfile.id);
  }
}
