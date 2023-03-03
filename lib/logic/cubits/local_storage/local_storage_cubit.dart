import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_state.dart';

class LocalStorageCubit extends Cubit<LocalStorageState> {
  LocalStorageCubit() : super(LocalStorageInitial());

  storeUserData(AfterLogin userDetails) async {
    emit(LocalStorageFetchingState());
    try {
      final userJson = jsonEncode(userDetails);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userdetails', userJson);
      log('User json storing in local storage:$userJson');
      emit(LocalStorageStoringDoneState());
      emit(LocalStorageFetchingDoneState(afterLogin: userDetails));
    } catch (e) {
      emit(LocalStorageStoringFailedState());
    }
  }

  Future<void> containsUser() async {
    final prefs = await SharedPreferences.getInstance();
    final bool containsUser = prefs.containsKey('userdetails');
    emit(LocalStorageUserDataPresentState(userDataPresent: containsUser));
  }

  Future<void> getUserDataFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('userdetails');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      final afterLogin = AfterLogin.fromJson(jsonMap);
      log('Allocated wards: ${afterLogin.userDetails!.allocatedWards!.length}');
      emit(LocalStorageFetchingDoneState(afterLogin: afterLogin));
    } else {
      log("Failed fetching local data");
      emit(LocalStorageFetchingFailedState());
    }
  }

  Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(const LocalStorageUserDataPresentState(userDataPresent: false));
  }
}
