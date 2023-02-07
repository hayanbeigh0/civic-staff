part of 'users_bloc.dart';

abstract class SearchUsersState extends Equatable {
  const SearchUsersState();
}

class SearchingUsersState extends SearchUsersState {
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [];
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
