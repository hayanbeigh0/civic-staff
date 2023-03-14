// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'local_storage_cubit.dart';

abstract class LocalStorageState extends Equatable {
  const LocalStorageState();
}

class LocalStorageInitial extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageStoringState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageStoringDoneState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageStoringFailedState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageFetchingFailedState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageFetchingDoneState extends LocalStorageState {
  final AfterLogin afterLogin;
  const LocalStorageFetchingDoneState({
    required this.afterLogin,
  });
  @override
  List<Object> get props => [afterLogin];
}

class LocalStorageFetchingState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageUserNotPresentState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageClearingUserFailedState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageClearingUserSuccessState extends LocalStorageState {
  @override
  List<Object> get props => [];
}

class LocalStorageUserDataPresentState extends LocalStorageState {
  final bool userDataPresent;
  final AfterLogin? userData;
  const LocalStorageUserDataPresentState({
    required this.userDataPresent,
    this.userData,
  });
  @override
  List<Object> get props => [userDataPresent];
}
