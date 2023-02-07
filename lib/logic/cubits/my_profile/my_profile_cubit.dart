import 'package:civic_staff/models/my_profile.dart';
import 'package:civic_staff/resources/repositories/my_profile/my_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final MyProfileRerpository myProfileRerpository;
  MyProfileCubit(this.myProfileRerpository) : super(MyProfileLoading());
  loadMyProfile() async {
    emit(MyProfileLoaded(
      myProfile: await myProfileRerpository.myProfile,
    ));
  }

  getMyProfile() async {
    emit(MyProfileLoading());
    await myProfileRerpository.loadMyProfileJson();
    emit(MyProfileLoaded(
      myProfile: myProfileRerpository.myProfile,
    ));
    emit(MyProfileLoaded(
      myProfile: myProfileRerpository.myProfile,
    ));
  }

  editMyProfile(MyProfile myProfile) {
    myProfileRerpository.myProfile.firstName = myProfile.firstName;
    myProfileRerpository.myProfile.lastName = myProfile.lastName;
    myProfileRerpository.myProfile.mobileNumber = myProfile.mobileNumber;
    myProfileRerpository.myProfile.email = myProfile.email;
    myProfileRerpository.myProfile.about = myProfile.about;
    emit(MyProfileLoaded(myProfile: myProfile));
  }
}
