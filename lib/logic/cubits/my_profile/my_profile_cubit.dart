import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/my_profile.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/resources/repositories/my_profile/my_profile.dart';
import 'package:dio/dio.dart';
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
    UserDetails userDetails = UserDetails.fromJson(
      jsonDecode(
        response.toString(),
      ),
    );
    log('Allocated wards length from my profile cubit:${AuthBasedRouting.afterLogin.userDetails!.allocatedWards!.length}');
    AuthBasedRouting.afterLogin.userDetails = UserDetails(
      active: userDetails.active,
      createdBy: userDetails.createdBy,
      emailID: userDetails.emailID,
      firstName: userDetails.firstName,
      lastName: userDetails.lastName,
      mobileNumber: userDetails.mobileNumber,
      municipalityID: userDetails.municipalityID,
      notificationToken: userDetails.notificationToken,
      profilePicture: userDetails.profilePicture,
      role: userDetails.role,
      staffID: userDetails.staffID,
      allocatedWards: AuthBasedRouting.afterLogin.userDetails!.allocatedWards!,
    );
    emit(
      MyProfileLoaded(
        myProfile: MyProfile(
          about: '',
          allocatedWards:
              AuthBasedRouting.afterLogin.userDetails!.allocatedWards!,
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
      ),
    );
  }

  editMyProfile(MyProfile myProfile) async {
    emit(MyProfileEditingStartedState());
    final userDetails = UserDetails(
      active: AuthBasedRouting.afterLogin.userDetails!.active,
      emailID: myProfile.email,
      firstName: myProfile.firstName,
      lastName: myProfile.lastName,
      mobileNumber: AuthBasedRouting.afterLogin.userDetails!.mobileNumber,
      municipalityID: AuthBasedRouting.afterLogin.userDetails!.municipalityID,
      staffID: AuthBasedRouting.afterLogin.userDetails!.staffID,
      role: AuthBasedRouting.afterLogin.userDetails!.role,
    );
    // emit(MyProfileLoading());
    try {
      final response = await myProfileRerpository.editProfile(userDetails);
      UserDetails newUserDetails = UserDetails.fromJson(
        jsonDecode(
          response.toString(),
        ),
      );
      AuthBasedRouting.afterLogin.userDetails = UserDetails(
        active: userDetails.active,
        createdBy: userDetails.createdBy,
        emailID: userDetails.emailID,
        firstName: userDetails.firstName,
        lastName: userDetails.lastName,
        mobileNumber: userDetails.mobileNumber,
        municipalityID: userDetails.municipalityID,
        notificationToken: userDetails.notificationToken,
        profilePicture: userDetails.profilePicture,
        role: userDetails.role,
        staffID: userDetails.staffID,
        allocatedWards:
            AuthBasedRouting.afterLogin.userDetails!.allocatedWards!,
      );
      emit(MyProfileEditingDoneState());
      // log("new user details1: ${newUserDetails.firstName}");
      // log("new user details2: ${AuthBasedRouting.afterLogin.userDetails!.firstName}");
    } on DioError catch (e) {
      emit(MyProfileEditingFailedState());
      log(e.response!.data);
    }
  }
}
