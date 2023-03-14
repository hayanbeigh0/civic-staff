import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/my_profile.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/presentation/screens/home/profile/edit_profile.dart';
import 'package:civic_staff/presentation/screens/login/login.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/secondary_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final Completer<GoogleMapController> _controller = Completer();
  final Map grievanceTypeName = {
    "GARB": "Garbage collection",
    "ELECT": "Electricity",
    "CERT": "Certificate request",
    "DUMM": "Dummy",
    "HOUSE": "House plan approval",
    "LIGHT": "Street lighting",
    "OTHER": "Others",
    "ROAD": "Road maintenance / Construction",
    "WATER": "Water supply / drainage",
  };

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MyProfileCubit>(context).getMyProfile(
        AuthBasedRouting.afterLogin.userDetails!.staffID.toString());
    return Scaffold(
      body: BlocConsumer<MyProfileCubit, MyProfileState>(
        listener: (context, state) {
          if (state is ProfilePictureUploadingSuccessState) {
            log('Uploaded profile picture successfully');
            UserDetails userDetails = AuthBasedRouting.afterLogin.userDetails!;
            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
              MyProfile(
                muncipality: userDetails.municipalityID,
                profilePicture:
                    'https://d1zwm96bdz9d2w.cloudfront.net/${state.s3uploadResult.uploadResult!.key1!}',
                about: '',
                allocatedWards:
                    AuthBasedRouting.afterLogin.userDetails!.allocatedWards!,
                city: '',
                country: '',
                email: userDetails.emailID,
                firstName: userDetails.firstName,
                id: userDetails.staffID,
                lastName: userDetails.lastName,
                latitude: '',
                longitude: '',
                mobileNumber: userDetails.mobileNumber,
                streetName: '',
              ),
            );
          }
          if (state is MyProfileEditingDoneState) {
            BlocProvider.of<MyProfileCubit>(context).getMyProfile(
                AuthBasedRouting.afterLogin.userDetails!.staffID.toString());
          }
          if (state is MyProfileEditingDoneState) {
            SnackBars.sucessMessageSnackbar(
                context, '✅ Profile updated successfully.');
          }
          if (state is MyProfileEditingFailedState) {
            SnackBars.errorMessageSnackbar(context, '⚠️Something went wrong!');
          }
        },
        builder: (context, state) {
          if (state is MyProfileEditingStartedState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.colorPrimary,
              ),
            );
          }
          if (state is ProfilePictureUploadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.colorPrimary,
              ),
            );
          }
          if (state is MyProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.colorPrimary,
              ),
            );
          }
          if (state is MyProfileLoaded) {
            return Column(
              children: [
                PrimaryTopShape(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        SafeArea(
                          bottom: false,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.sp),
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/arrowleft.svg',
                                        color: AppColors.colorWhite,
                                        height: 18.sp,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        LocaleKeys.profile_screenTitle.tr(),
                                        style: AppStyles.screenTitleStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    EditProfileScreen.routeName,
                                    arguments: {
                                      'my_profile': state.myProfile,
                                    },
                                  ).then(
                                    (_) =>
                                        BlocProvider.of<MyProfileCubit>(context)
                                            .getMyProfile(
                                      AuthBasedRouting
                                          .afterLogin.userDetails!.staffID
                                          .toString(),
                                    ),
                                  );
                                },
                                child: Text(
                                  LocaleKeys.profile_edit.tr(),
                                  style: AppStyles.appBarActionsTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                InkWell(
                                  onLongPress: () {
                                    _showPicker(context);
                                  },
                                  child: CircleAvatar(
                                    radius: 35.w,
                                    backgroundColor:
                                        AppColors.colorPrimaryExtraLight,
                                    child: ClipOval(
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: state.userDetails
                                                          .profilePicture !=
                                                      null ||
                                                  state.userDetails
                                                          .profilePicture ==
                                                      ''
                                              ? Image.network(
                                                  state.userDetails
                                                      .profilePicture!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Center(
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 60.sp,
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.photo_camera,
                                                      size: 30.sp,
                                                    ),
                                                    onPressed: () {
                                                      _showPicker(context);
                                                    },
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Positioned(
                                //   right: 0,
                                //   top: 0,
                                //   child: IconButton(
                                //     icon: Icon(
                                //       Icons.edit,
                                //       size: 24.sp,
                                //       color: AppColors.textColorLight,
                                //     ),
                                //     onPressed: () {},
                                //   ),
                                // ),
                              ],
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.myProfile.firstName.toString(),
                                  style: AppStyles.userDisplayNameTextStyle,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  state.myProfile.city.toString(),
                                  style: AppStyles.userDisplayCityTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.call,
                              color: AppColors.colorWhite,
                              size: 16.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              state.myProfile.mobileNumber.toString(),
                              style:
                                  AppStyles.userDisplayCityTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppColors.colorWhite,
                              size: 16.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              state.myProfile.email.toString(),
                              style:
                                  AppStyles.userDisplayCityTextStyle.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryDisplayField(
                            title: 'Municipality',
                            value: AuthBasedRouting.afterLogin.masterData!
                                .firstWhere((element) =>
                                    element.sK ==
                                    AuthBasedRouting
                                        .afterLogin.userDetails!.municipalityID)
                                .name
                                .toString(),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            LocaleKeys.profile_allocatedGrievancesAndWards.tr(),
                            style: AppStyles.inputAndDisplayTitleStyle,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimaryLight,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: AuthBasedRouting
                                  .afterLogin.userDetails!.allocatedWards!
                                  .map(
                                    (e) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0.sp,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AuthBasedRouting
                                                      .afterLogin
                                                      .userDetails!
                                                      .allocatedWards!
                                                      .indexOf(e) ==
                                                  0
                                              ? const SizedBox()
                                              : const Divider(
                                                  height: 1.1,
                                                  color:
                                                      AppColors.colorGreyLight,
                                                ),
                                          Text(
                                            '${grievanceTypeName[e.grievanceType]}: ',
                                            style: AppStyles
                                                .inputAndDisplayTitleStyle,
                                          ),

                                          ...e.wardNumber!
                                              .toList()
                                              .map(
                                                (e) => Column(
                                                  children: [
                                                    Text(
                                                      AuthBasedRouting
                                                          .afterLogin
                                                          .wardDetails!
                                                          .firstWhere((element) =>
                                                              element
                                                                  .wardNumber ==
                                                              e)
                                                          .wardName
                                                          .toString(),
                                                      style: AppStyles
                                                          .descriptiveTextStyle
                                                          .copyWith(
                                                        height: null,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                          // e.indexOf(e) <
                                          //               state
                                          //                       .myProfile
                                          //                       .allocatedWards!
                                          //                       .length -
                                          //                   1
                                          //           ?
                                          // Divider(
                                          //   height: 1.1,
                                          //   color: AppColors.colorGreyLight,
                                          // )
                                          // : SizedBox()
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlocListener<LocalStorageCubit, LocalStorageState>(
                  listener: (context, state) {
                    if (state is LocalStorageClearingUserFailedState) {
                      SnackBars.sucessMessageSnackbar(
                          context, 'Local Storage clearing failed!');
                    }
                    if (state is LocalStorageClearingUserSuccessState) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.routeName,
                        (route) => false,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SecondaryButton(
                        buttonText: LocaleKeys.profile_logout.tr(),
                        isLoading: false,
                        onTap: () {
                          BlocProvider.of<LocalStorageCubit>(context)
                              .clearStorage();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5.h,
              ),
              SizedBox(
                width: 100.w,
                child: const Divider(
                  thickness: 2,
                  color: AppColors.textColorDark,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.sp),
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () async {
                        await pickPhoto();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () async {
                        await capturePhoto();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickPhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    log('Picking image');
    final Uint8List imageBytes = await pickedFile!.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    BlocProvider.of<MyProfileCubit>(context).uploadProfilePicture(
      encodedProfilePictureFile: base64Image,
      fileType: 'image',
      staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
    );
    Navigator.of(context).pop();
  }

  Future<void> capturePhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    final Uint8List imageBytes = await pickedFile!.readAsBytes();
    final String base64Image = base64Encode(imageBytes);
    BlocProvider.of<MyProfileCubit>(context).uploadProfilePicture(
      encodedProfilePictureFile: base64Image,
      fileType: 'image',
      staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
    );

    Navigator.of(context).pop();
  }
}
