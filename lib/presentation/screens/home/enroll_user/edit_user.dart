import 'dart:async';
import 'dart:developer';

import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/my_profile.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:civic_staff/presentation/widgets/primary_text_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditUserScreen extends StatefulWidget {
  static const routeName = '/editUserScreen';
  const EditUserScreen({
    super.key,
    required this.user,
  });
  final User user;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  final _formKey = GlobalKey<FormState>();

  late List<WardDetails> wards;
  // late List<dynamic> muncipality;
  // final Map wardsAndMuncipality = {
  //   '1': ['10', '11', '12', '13', '14'],
  //   '2': ['15', '16', '17', '18', '19'],
  //   '3': ['20', '21', '22', '23', '24'],
  //   '4': ['30', '31', '32', '33', '34'],
  //   'MUNCI-de7f8138-7ce5-4a91-a21a-98dd0b2de9f9': [
  //     '35',
  //     '36',
  //     '37',
  //     '38',
  //     '39',
  //     '2',
  //     '3',
  //     '4',
  //   ],
  // };

  String? wardDropdownValue;
  String? muncipalityDropdownValue;

  bool showWardDropdownError = false;
  bool showMuncipalityDropdownError = false;

  @override
  void initState() {
    firstNameController.text = widget.user.firstName.toString();
    lastNameController.text = widget.user.lastName.toString();
    contactNumberController.text = widget.user.mobileNumber.toString();
    emailController.text = widget.user.emailId.toString();
    aboutController.text = widget.user.about.toString();
    wardDropdownValue = widget.user.wardNumber;
    muncipalityDropdownValue = widget.user.municipalityId;
    wards = AuthBasedRouting.afterLogin.wardDetails!
        .where((element) =>
            element.municipalityID ==
            AuthBasedRouting.afterLogin.userDetails!.municipalityID!)
        .toList();
    wardDropdownValue = wards
        .firstWhere((element) => element.wardNumber == widget.user.wardNumber)
        .wardName;
    // muncipality = wardsAndMuncipality.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('Hello');
    log('Created Date: ${widget.user.createdDate.toString()}');
    return Scaffold(
      body: Column(
        children: [
          PrimaryTopShape(
            height: 150.h,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            color: AppColors.colorWhite,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Edit User',
                          style: AppStyles.screenTitleStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextField(
                        fieldValidator: (p0) {
                          return validateFirstName(p0.toString());
                        },
                        title: LocaleKeys.editProfile_firstName.tr(),
                        hintText: LocaleKeys.editProfile_firstName.tr(),
                        textEditingController: firstNameController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryTextField(
                        fieldValidator: (p0) {
                          return validateLastName(p0.toString());
                        },
                        title: LocaleKeys.editProfile_lastName.tr(),
                        hintText: LocaleKeys.editProfile_lastName.tr(),
                        textEditingController: lastNameController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryTextField(
                        // fieldValidator: (p0) => validateEmailAddress(
                        //   p0.toString(),
                        // ),
                        title: LocaleKeys.editProfile_email.tr(),
                        hintText: 'you@example.com',
                        textEditingController: emailController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryDisplayField(
                        fillColor: AppColors.colorDisabledTextField,
                        title: LocaleKeys.editProfile_contactNumber.tr(),
                        value: contactNumberController.text,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryTextField(
                        maxLines: 8,
                        fieldValidator: (p0) => validateAbout(
                          p0.toString(),
                        ),
                        title: LocaleKeys.editProfile_about.tr(),
                        hintText: LocaleKeys.editProfile_aboutHint.tr(),
                        textEditingController: aboutController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
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
                      // Text(
                      //   'Muncipality',
                      //   style: AppStyles.inputAndDisplayTitleStyle,
                      // ),
                      // SizedBox(
                      //   height: 5.h,
                      // ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: AppColors.colorPrimaryLight,
                      //     borderRadius: BorderRadius.circular(10.r),
                      //   ),
                      //   padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      //   child: DropdownButtonFormField(
                      //     value: muncipalityDropdownValue,
                      //     isExpanded: true,
                      //     iconSize: 24.sp,
                      //     icon: const Icon(
                      //       Icons.keyboard_arrow_down,
                      //     ),
                      //     hint: Text(
                      //       'Select muncipality',
                      //       style: AppStyles.dropdownTextStyle,
                      //     ),
                      //     decoration: InputDecoration(
                      //       labelStyle: AppStyles.dropdownTextStyle,
                      //       border: InputBorder.none,
                      //     ),
                      //     items: muncipality
                      //         .map(
                      //           (item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               maxLines: 1,
                      //               style: AppStyles.dropdownTextStyle,
                      //             ),
                      //           ),
                      //         )
                      //         .toList(),
                      //     onChanged: (value) {
                      //       setState(() {
                      //         muncipalityDropdownValue = value.toString();
                      //         wardDropdownValue = null;
                      //         wards = wardsAndMuncipality[value];
                      //         showMuncipalityDropdownError = false;
                      //       });
                      //     },
                      //     validator: (value) => validateWardNumber(
                      //       value.toString(),
                      //     ),
                      //   ),
                      // ),
                      // showMuncipalityDropdownError
                      //     ? Column(
                      //         children: [
                      //           SizedBox(
                      //             height: 5.h,
                      //           ),
                      //           Text(
                      //             LocaleKeys.enrollUsers_wardDropdownError.tr(),
                      //             style: AppStyles.errorTextStyle,
                      //           )
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        LocaleKeys.enrollUsers_ward.tr(),
                        style: AppStyles.inputAndDisplayTitleStyle,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimaryLight,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: DropdownButtonFormField(
                          value: wardDropdownValue,
                          isExpanded: true,
                          iconSize: 24.sp,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          hint: Text(
                            LocaleKeys.enrollUsers_wardDropdownInitialValue
                                .tr(),
                            style: AppStyles.dropdownTextStyle,
                          ),
                          decoration: InputDecoration(
                            labelStyle: AppStyles.dropdownTextStyle,
                            border: InputBorder.none,
                          ),
                          items: wards
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item.wardName,
                                  child: Text(
                                    item.wardName.toString(),
                                    maxLines: 1,
                                    style: AppStyles.dropdownTextStyle,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            wardDropdownValue = value.toString();
                            setState(() {
                              showWardDropdownError = false;
                            });
                          },
                          validator: (value) => validateWardNumber(
                            value.toString(),
                          ),
                        ),
                      ),
                      showWardDropdownError
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  LocaleKeys.enrollUsers_wardDropdownError.tr(),
                                  style: AppStyles.errorTextStyle,
                                )
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        LocaleKeys.editProfile_location.tr(),
                        style: AppStyles.inputAndDisplayTitleStyle,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Stack(
                        children: [
                          LocationMapField(
                            zoomEnabled: true,
                            mapController: _controller,
                            latitude: double.parse(
                              widget.user.latitude.toString(),
                            ),
                            longitude: double.parse(
                              widget.user.longitude.toString(),
                            ),
                          ),
                          Container(
                            height: 180.h,
                            alignment: Alignment.center,
                            child: Center(
                              child: Transform.translate(
                                offset: Offset(0, -10.h),
                                child: SvgPicture.asset(
                                  'assets/svg/marker.svg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      BlocBuilder<ReverseGeocodingCubit, ReverseGeocodingState>(
                        builder: (context, state) {
                          if (state is ReverseGeocodingLoaded) {
                            return BlocBuilder<CurrentLocationCubit,
                                    CurrentLocationState>(
                                builder: (context, currentLocationState) {
                              if (currentLocationState
                                  is CurrentLocationLoaded) {
                                return BlocConsumer<UsersBloc,
                                    SearchUsersState>(
                                  listener: (context, userState) {
                                    if (userState is EditingUserFailedState) {
                                      SnackBars.errorMessageSnackbar(context,
                                          'An unknown error occurred!');
                                    }
                                    if (userState is UserEditedState) {
                                      SnackBars.sucessMessageSnackbar(
                                          context, 'User has been edited!');
                                      Navigator.of(context)
                                          .pop({"user": userState.user});
                                    }
                                  },
                                  builder: (context, userState) {
                                    if (userState is EditingAUserState) {
                                      return Align(
                                        alignment: Alignment.bottomRight,
                                        child: PrimaryButton(
                                          enabled: true,
                                          isLoading: true,
                                          onTap: () {},
                                          buttonText: LocaleKeys
                                              .editProfile_submit
                                              .tr(),
                                        ),
                                      );
                                    }
                                    return Align(
                                      alignment: Alignment.bottomRight,
                                      child: PrimaryButton(
                                        isLoading: false,
                                        onTap: () {
                                          if (wardDropdownValue == null) {
                                            setState(() {
                                              showWardDropdownError = true;
                                            });
                                          }
                                          if (muncipalityDropdownValue ==
                                              null) {
                                            setState(() {
                                              showMuncipalityDropdownError =
                                                  true;
                                            });
                                          }
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              !showMuncipalityDropdownError &&
                                              !showWardDropdownError) {
                                            BlocProvider.of<UsersBloc>(context)
                                                .add(
                                              EditUserEvent(
                                                user: User(
                                                  about: aboutController.text,
                                                  countryCode: '+91',
                                                  emailId: emailController.text,
                                                  firstName:
                                                      firstNameController.text,
                                                  userId: widget.user.userId,
                                                  lastName:
                                                      lastNameController.text,
                                                  latitude: LocationMapField
                                                      .pickedLoc.latitude
                                                      .toString(),
                                                  longitude: LocationMapField
                                                      .pickedLoc.longitude
                                                      .toString(),
                                                  mobileNumber:
                                                      contactNumberController
                                                          .text,
                                                  address: state.street +
                                                      state.locality +
                                                      state.countryName,
                                                  wardNumber: wards
                                                      .firstWhere((element) =>
                                                          element.wardName ==
                                                          wardDropdownValue)
                                                      .wardNumber,
                                                  municipalityId: widget
                                                      .user.municipalityId,
                                                  active: widget.user.active,
                                                  createdDate:
                                                      widget.user.createdDate,
                                                  lastModifiedDate:
                                                      DateTime.now().toString(),
                                                  notificationToken: widget
                                                      .user.notificationToken,
                                                  profilePicture: '',
                                                  staffId: AuthBasedRouting
                                                      .afterLogin
                                                      .userDetails!
                                                      .staffID,
                                                ),
                                              ),
                                            );
                                          } else {}
                                        },
                                        buttonText:
                                            LocaleKeys.editProfile_submit.tr(),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Align(
                                alignment: Alignment.bottomRight,
                                child: PrimaryButton(
                                  enabled: false,
                                  isLoading: false,
                                  onTap: () {},
                                  buttonText:
                                      LocaleKeys.editProfile_submit.tr(),
                                ),
                              );
                            });
                          }
                          return Align(
                            alignment: Alignment.bottomRight,
                            child: PrimaryButton(
                              enabled: false,
                              isLoading: false,
                              onTap: () {},
                              buttonText: LocaleKeys.editProfile_submit.tr(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateWardNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editProfile_wardError.tr();
    }
    return null;
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editProfile_firstNameError.tr();
    }
    return null;
  }

  String? validateAbout(String value) {
    // if (value.isEmpty) {
    //   return LocaleKeys.editProfile_aboutError.tr();
    // }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editProfile_lastNameError.tr();
    }
    return null;
  }

  String? validateEmailAddress(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editProfile_emailError.tr();
    }
    return null;
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editProfile_mobileNumberRequiredErrorMessage.tr();
    }
    if (value.length != 10) {
      return LocaleKeys.editProfile_mobileNumberLengthErrorMessage.tr();
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return LocaleKeys.editProfile_mobileNumberInputTypeError.tr();
    }
    return null;
  }
}
