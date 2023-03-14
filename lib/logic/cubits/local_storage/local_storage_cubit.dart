import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:civic_staff/models/user_details.dart';

part 'local_storage_state.dart';

class LocalStorageCubit extends Cubit<LocalStorageState> {
  LocalStorageCubit() : super(LocalStorageInitial());
  late final SharedPreferences prefs;
  AfterLogin? afterLogin;
  storeUserData(AfterLogin userDetails) async {
    emit(LocalStorageFetchingState());
    try {
      final userJson = jsonEncode(userDetails);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('staff-userdetails', userJson);
      log('User json storing in local storage:$userJson');
      final AfterLogin newUserDetails = AfterLogin.fromJson(
          jsonDecode(prefs.getString('staff-userdetails').toString()));
      AuthBasedRouting.afterLogin = newUserDetails;
      emit(LocalStorageStoringDoneState());
      emit(LocalStorageFetchingDoneState(afterLogin: newUserDetails));
    } catch (e) {
      log('Error while storing to local storage!');
      emit(LocalStorageStoringFailedState());
    }
  }

  Future<void> containsUser() async {
    final prefs = await SharedPreferences.getInstance();
    final bool containsUser = prefs.containsKey('staff-userdetails');
    log('User data present is $containsUser');
    emit(LocalStorageUserDataPresentState(userDataPresent: containsUser));
  }

  Future<void> getUserDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final jsonString = prefs.getString('staff-userdetails');
      if (jsonString != null) {
        final jsonMap = jsonDecode(jsonString);
        afterLogin = AfterLogin.fromJson(jsonMap);
        emit(LocalStorageFetchingDoneState(afterLogin: afterLogin!));
      } else {
        log("Failed fetching local data");
        emit(LocalStorageFetchingFailedState());
      }
    } catch (_) {
      emit(LocalStorageFetchingFailedState());
    }
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    afterLogin = null;
    await prefs.remove('staff-userdetails');
    await prefs.clear();
    final containsUser = prefs.containsKey('staff-userdetails');
    if (!containsUser) {
      emit(const LocalStorageUserDataPresentState(userDataPresent: false));
      emit(LocalStorageClearingUserSuccessState());
    } else {
      emit(LocalStorageClearingUserFailedState());
    }
  }
}
