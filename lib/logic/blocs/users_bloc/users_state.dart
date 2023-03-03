// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'users_bloc.dart';

abstract class SearchUsersState extends Equatable {
  const SearchUsersState();
}

class SearchingUsersState extends SearchUsersState {
  final int selectedFilterNumber;
  const SearchingUsersState({
    required this.selectedFilterNumber,
  });
  @override
  List<Object?> get props => [selectedFilterNumber];
}

class LoadedUsersState extends SearchUsersState {
  final int selectedFilterNumber;
  final List<User> userList;
  const LoadedUsersState({
    required this.selectedFilterNumber,
    required this.userList,
  });
  @override
  List<Object?> get props => [userList, selectedFilterNumber];
}

class LoadingUsersFailedState extends SearchUsersState {
  final int selectedFilterNumber;
  const LoadingUsersFailedState({
    required this.selectedFilterNumber,
  });
  @override
  List<Object?> get props => [selectedFilterNumber];
}

class EnrollingAUserFailedState extends SearchUsersState {
  @override
  List<Object?> get props => [];
}

class EnrollingAUserState extends SearchUsersState {
  final bool loading;
  const EnrollingAUserState({
    required this.loading,
  });
  @override
  List<Object?> get props => [loading];
}

class UserEnrolledState extends SearchUsersState {
  final User user;
  const UserEnrolledState({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}

class EditingUserFailedState extends SearchUsersState {
  @override
  List<Object?> get props => [];
}

class EditingAUserState extends SearchUsersState {
  final bool loading;
  const EditingAUserState({
    required this.loading,
  });
  @override
  List<Object?> get props => [loading];
}

class UserEditedState extends SearchUsersState {
  final User user;
  const UserEditedState({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}

class GettingUserByIdState extends SearchUsersState {
  @override
  List<Object?> get props => [];
}

class GettingUserByIdFailedState extends SearchUsersState {
  @override
  List<Object?> get props => [];
}

class LoadedUserByIdState extends SearchUsersState {
  final User user;
  const LoadedUserByIdState({
    required this.user,
  });
  @override
  List<Object?> get props => [user];
}
