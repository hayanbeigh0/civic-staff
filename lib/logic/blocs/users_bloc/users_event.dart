part of 'users_bloc.dart';

abstract class SearchUsersEvent extends Equatable {
  const SearchUsersEvent();
}

class LoadUsersEvent extends SearchUsersEvent {
  final int radioValue;
  const LoadUsersEvent(this.radioValue);

  @override
  List<Object?> get props => [radioValue];
}

class SearchUserByNameEvent extends SearchUsersEvent {
  final String name;
  const SearchUserByNameEvent({
    required this.name,
  });
  @override
  List<Object?> get props => [name];
}

class SearchUserByStreetEvent extends SearchUsersEvent {
  final String streetName;
  const SearchUserByStreetEvent({
    required this.streetName,
  });
  @override
  List<Object?> get props => [streetName];
}

class SearchUserByMobileEvent extends SearchUsersEvent {
  final String mobileNumber;
  const SearchUserByMobileEvent({
    required this.mobileNumber,
  });
  @override
  List<Object?> get props => [mobileNumber];
}

class EnrollAUserEvent extends SearchUsersEvent {
  final User user;
  const EnrollAUserEvent({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}
