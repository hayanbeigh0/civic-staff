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

class LoadAllUsersEvent extends SearchUsersEvent {
  final int selectedFilterNumber;
  const LoadAllUsersEvent(this.selectedFilterNumber);

  @override
  List<Object?> get props => [selectedFilterNumber];
}

class SearchUserByNameEvent extends SearchUsersEvent {
  final String name;
  final String municipalityId;
  const SearchUserByNameEvent({
    required this.name,
    required this.municipalityId,
  });
  @override
  List<Object?> get props => [name, municipalityId];
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

class EditUserEvent extends SearchUsersEvent {
  final User user;
  const EditUserEvent({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class GetUserByIdEvent extends SearchUsersEvent {
  final String userId;
  const GetUserByIdEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
