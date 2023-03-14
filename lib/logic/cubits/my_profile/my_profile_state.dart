// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'my_profile_cubit.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();
}

class MyProfileLoading extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class MyProfileEditingStartedState extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class MyProfileEditingDoneState extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class MyProfileEditingFailedState extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class ProfilePictureUploadingState extends MyProfileState {
  @override
  List<Object?> get props => [];
}

class ProfilePictureUploadingSuccessState extends MyProfileState {
  final S3UploadResult s3uploadResult;
  const ProfilePictureUploadingSuccessState({
    required this.s3uploadResult,
  });
  @override
  List<Object?> get props => [];
}

class ProfilePictureUploadingFailedState extends MyProfileState {
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
