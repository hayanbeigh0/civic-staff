// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'my_profile_cubit.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();
}

class MyProfileLoading extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class MyProfileLoaded extends MyProfileState {
  final UserDetails userDetails;
  final MyProfile myProfile;
  const MyProfileLoaded({required this.myProfile, required this.userDetails});

  @override
  List<Object?> get props => [userDetails, myProfile];
}
