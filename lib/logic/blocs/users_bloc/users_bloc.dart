import 'dart:developer';

import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/resources/repositories/Users/user_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  UserRepository userRepository;
  String selectedFilter = 'name';
  List<User> usersList = [];
  UsersBloc(this.userRepository)
      : super(const SearchingUsersState(selectedFilterNumber: 1)) {
    on<LoadUsersEvent>((event, emit) async {
      emit(const SearchingUsersState(selectedFilterNumber: 1));
      try {
        final response = await userRepository.getAllUsers();
        // log(response.data.toString());
        final responseBody = response.data;
        usersList = List<User>.from(
          responseBody.map((e) => User.fromJson((e))).toList(),
        );
        if (usersList.isEmpty) {
          emit(LoadingUsersFailedState(selectedFilterNumber: event.radioValue));
        } else {
          emit(LoadedUsersState(
              userList: usersList, selectedFilterNumber: event.radioValue));
        }
      } on DioError catch (_) {
        emit(LoadingUsersFailedState(selectedFilterNumber: event.radioValue));
      }
      userRepository.loadUserJson();
    });
    on<LoadAllUsersEvent>((event, emit) async {
      emit(const SearchingUsersState(selectedFilterNumber: 1));
      try {
        final response = await userRepository.getAllUsers();
        // log('Response: ${response.data.toString()}');
        final responseBody = response.data;
        usersList = List<User>.from(
          responseBody.map((e) => User.fromJson((e))).toList(),
        );
        if (usersList.isEmpty) {
          emit(const LoadingUsersFailedState(selectedFilterNumber: 0));
        } else {
          emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 0));
        }
      } on DioError catch (_) {
        emit(const LoadingUsersFailedState(selectedFilterNumber: 0));
      }
    });

    on<SearchUserByNameEvent>((event, emit) async {
      emit(const SearchingUsersState(selectedFilterNumber: 1));
      // userRepository.loadUserJson();
      try {
        // final response = await userRepository.getUserByFilter(
        //   {"firstName": event.name, "MunicipalityID": event.municipalityId},
        // );
        // log(response.data.toString());
        // final responseBody = response.data;
        // usersList = List<User>.from(
        //   responseBody.map((e) => User.fromJson((e))).toList(),
        // );
        List<User> usersByName = usersList.where(
          (element) {
            return element.firstName!
                .replaceAll(' ', '')
                .toLowerCase()
                .contains(event.name.toLowerCase());
          },
        ).toList();
        usersByName
            .sort((a, b) => b.firstName!.compareTo(a.firstName.toString()));
        if (usersByName.isEmpty) {
          emit(const LoadingUsersFailedState(selectedFilterNumber: 1));
        } else {
          emit(
              LoadedUsersState(userList: usersByName, selectedFilterNumber: 1));
        }
        // if (usersList.isEmpty) {
        //   emit(const LoadingUsersFailedState(selectedFilterNumber: 1));
        // } else {
        //   emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 1));
        // }
      } on DioError catch (e) {
        emit(const LoadingUsersFailedState(selectedFilterNumber: 1));
        log(e.message.toString());
      }

      /// to resume from here...
    });
    on<SearchUserByMobileEvent>((event, emit) async {
      emit(const SearchingUsersState(selectedFilterNumber: 2));
      // userRepository.loadUserJson();
      try {
        // final Response response = await userRepository.getUserByFilter(
        //   {
        //     "mobileNumber": event.mobileNumber,
        //   },
        // );
        // final responseBody = response.data as List<dynamic>;
        // usersList = List<User>.from(
        //     responseBody.map((e) => User.fromJson((e))).toList());
        List<User> usersByMobileNumber = usersList.where(
          (element) {
            return element.mobileNumber!
                .toLowerCase()
                .replaceAll(' ', '')
                .contains(event.mobileNumber.toLowerCase());
          },
        ).toList();
        usersByMobileNumber.sort(
          (a, b) => b.mobileNumber!.compareTo(a.mobileNumber.toString()),
        );
        if (usersByMobileNumber.isEmpty) {
          emit(const LoadingUsersFailedState(selectedFilterNumber: 2));
        } else {
          emit(LoadedUsersState(
              userList: usersByMobileNumber, selectedFilterNumber: 2));
        }
        // if (usersList.isEmpty) {
        //   emit(const LoadingUsersFailedState(selectedFilterNumber: 2));
        // } else {
        //   emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 2));
        // }
      } on DioError catch (_) {
        emit(const LoadingUsersFailedState(selectedFilterNumber: 2));
      }
    });
    on<SearchUserByStreetEvent>((event, emit) async {
      try {
        emit(const SearchingUsersState(selectedFilterNumber: 3));
        // userRepository.loadUserJson();
        // final Response response = await userRepository.getUserByFilter(
        //   {
        //     "firstName": null,
        //     "mobileNumber": null,
        //     "streetName": event.streetName
        //   },
        // );
        // final responseBody = response.data as List<dynamic>;
        // usersList = List<User>.from(
        //     responseBody.map((e) => User.fromJson((e))).toList());

        // if (usersList.isEmpty) {
        //   emit(const LoadingUsersFailedState(selectedFilterNumber: 3));
        // } else {
        //   emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 3));
        // }
        List<User> usersByMobileStreetName = usersList.where(
          (element) {
            return element.address!
                .toLowerCase()
                .replaceAll(' ', '')
                .contains(event.streetName.toLowerCase());
          },
        ).toList();
        usersByMobileStreetName.sort(
          (a, b) => a.address!.compareTo(b.address.toString()),
        );
        if (usersByMobileStreetName.isEmpty) {
          emit(const LoadingUsersFailedState(selectedFilterNumber: 3));
        } else {
          emit(LoadedUsersState(
              userList: usersByMobileStreetName, selectedFilterNumber: 3));
        }
      } on DioError catch (_) {
        emit(const LoadingUsersFailedState(selectedFilterNumber: 3));
      }
    });
    on<EnrollAUserEvent>((event, emit) async {
      emit(const EnrollingAUserState(loading: true));
      try {
        final response = await userRepository.getAllUsers();
        for (var i = 0; i < response.data.length; i++) {
          if (event.user.mobileNumber == response.data[i]['MobileNumber']) {
            emit(EnrollingAUserFailedState());
            throw (Exception("error"));
          }
        }
        log("This is logged");
        await userRepository.addUser(event.user);
        emit(UserEnrolledState(user: event.user));
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.sendTimeout) {
          emit(EnrollingAUserFailedState());
        }
      } catch (e) {
        emit(EnrollingAUserFailedState());
        log("Emitted");
      }
    });
    on<EditUserEvent>((event, emit) async {
      emit(const EditingAUserState(loading: true));
      try {
        final Response response = await userRepository.editUser(event.user);
        if (response.statusCode == 200) {
          emit(UserEditedState(user: User.fromJson(response.data)));
        }
      } on DioError catch (e) {
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.sendTimeout) {
          emit(EditingUserFailedState());
        }
      }
    });
    on<GetUserByIdEvent>((event, emit) async {
      emit(GettingUserByIdState());
      try {
        final Response response =
            await userRepository.getUserById(event.userId);
        if (response.statusCode == 200) {
          emit(LoadedUserByIdState(user: User.fromJson(response.data)));
        }
      } on DioError catch (e) {
        log('Error: ${e.message!}');
        if (e.type == DioErrorType.connectionTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.sendTimeout) {
          emit(GettingUserByIdFailedState());
        }
      }
    });
  }
}
