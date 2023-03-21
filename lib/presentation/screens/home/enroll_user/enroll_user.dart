import 'dart:async';
import 'dart:developer';

import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/snackbars.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_text_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EnrollUser extends StatefulWidget {
  static const routeName = '/enrollUser';
  const EnrollUser({super.key});

  @override
  State<EnrollUser> createState() => _EnrollUserState();
}

class _EnrollUserState extends State<EnrollUser> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController contactNumberController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController wardNumberController = TextEditingController();

  final Completer<GoogleMapController> _controller = Completer();

  final _formKey = GlobalKey<FormState>();

  final FocusNode firstNameNode = FocusNode();

  @override
  initState() {
    BlocProvider.of<LocalStorageCubit>(context).getUserDataFromLocalStorage();
    BlocProvider.of<CurrentLocationCubit>(context).getCurrentLocation();
    wards = AuthBasedRouting.afterLogin.wardDetails!
        .where((element) =>
            element.municipalityID ==
            AuthBasedRouting.afterLogin.userDetails!.municipalityID!)
        .toList();
    wards.sort(
      (a, b) => int.parse(a.wardNumber!).compareTo(int.parse(b.wardNumber!)),
    );
    super.initState();
  }

  late List<WardDetails> wards;

  String? wardDropdownValue;
  String? muncipalityDropdownValue;

  bool showWardDropdownError = false;
  bool showMuncipalityDropdownError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PrimaryTopShape(
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
                    bottom: false,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                LocaleKeys.enrollUsers_screenTitle.tr(),
                                style: AppStyles.screenTitleStyle,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LocalStorageCubit, LocalStorageState>(
              builder: (context, state) {
                if (state is LocalStorageFetchingDoneState) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                      child: enrollUserForm(state),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorPrimary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Form enrollUserForm(var authenticationSuccessState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextField(
            focusNode: firstNameNode,
            fieldValidator: (p0) {
              return validateFirstName(p0.toString());
            },
            title: '${LocaleKeys.enrollUsers_firstName.tr()}*',
            hintText: LocaleKeys.enrollUsers_firstName.tr(),
            textEditingController: firstNameController,
          ),
          SizedBox(
            height: 12.h,
          ),
          PrimaryTextField(
            fieldValidator: (p0) {
              return validateLastName(p0.toString());
            },
            title: '${LocaleKeys.enrollUsers_lastName.tr()}*',
            hintText: LocaleKeys.enrollUsers_lastName.tr(),
            textEditingController: lastNameController,
          ),
          SizedBox(
            height: 12.h,
          ),
          PrimaryTextField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            fieldValidator: (p0) => validateMobileNumber(
              p0.toString(),
            ),
            title: '${LocaleKeys.enrollUsers_contactNumber.tr()}*',
            hintText: LocaleKeys.enrollUsers_contactNumberHint.tr(),
            textEditingController: contactNumberController,
          ),
          SizedBox(
            height: 12.h,
          ),
          PrimaryTextField(
            fieldValidator: (p0) => validateEmailAddress(
              p0.toString(),
            ),
            title: LocaleKeys.enrollUsers_email.tr(),
            hintText: LocaleKeys.enrollUsers_emailHint.tr(),
            textEditingController: emailController,
          ),
          SizedBox(
            height: 12.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${LocaleKeys.enrollUsers_ward.tr()}*',
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
                    LocaleKeys.enrollUsers_wardDropdownInitialValue.tr(),
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
                        Padding(
                          padding: EdgeInsets.only(left: 16.0.sp),
                          child: Text(
                            LocaleKeys.enrollUsers_wardDropdownError.tr(),
                            style: AppStyles.errorTextStyle,
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            '${LocaleKeys.enrollUsers_location.tr()}*',
            style: AppStyles.inputAndDisplayTitleStyle,
          ),
          SizedBox(
            height: 5.h,
          ),
          BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
            builder: (context, state) {
              if (state is CurrentLocationLoaded) {
                return Stack(
                  children: [
                    LocationMapField(
                      textFieldsEnabled: true,
                      gesturesEnabled: true,
                      myLocationEnabled: true,
                      zoomEnabled: true,
                      mapController: _controller,
                      latitude: state.latitude,
                      longitude: state.longitude,
                      addressFieldValidator: (p0) =>
                          validateAddress(p0.toString()),
                      countryFieldValidator: (p0) =>
                          validateCountry(p0.toString()),
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
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.colorPrimaryExtraLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                height: 180.h,
                width: double.infinity,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.colorPrimary,
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 50.h,
          ),
          BlocBuilder<ReverseGeocodingCubit, ReverseGeocodingState>(
            builder: (context, state) {
              if (state is ReverseGeocodingLoaded) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child:
                      BlocBuilder<CurrentLocationCubit, CurrentLocationState>(
                    builder: (context, currentLocationState) {
                      if (currentLocationState is CurrentLocationLoaded) {
                        return BlocConsumer<UsersBloc, SearchUsersState>(
                          listener: (context, userState) {
                            if (userState is UserEnrolledState) {
                              FocusScope.of(context)
                                  .requestFocus(firstNameNode);
                              SnackBars.sucessMessageSnackbar(
                                  context,
                                  LocaleKeys
                                      .enrollUsers_userEnrolledSuccessMessage
                                      .tr());

                              firstNameController.text = '';
                              lastNameController.text = '';
                              emailController.text = '';
                              contactNumberController.text = '';
                              wardNumberController.text = '';
                            }
                            if (state is EnrollingAUserFailedState) {
                              SnackBars.errorMessageSnackbar(
                                  context,
                                  LocaleKeys
                                      .enrollUsers_userEnrolledFailedMessage
                                      .tr());
                            }
                          },
                          builder: (context, userState) {
                            if (userState is EnrollingAUserState) {
                              return PrimaryButton(
                                enabled: true,
                                isLoading: true,
                                onTap: () {
                                  log('Not Working');
                                },
                                buttonText: LocaleKeys.enrollUsers_submit.tr(),
                              );
                            }
                            return PrimaryButton(
                              isLoading: false,
                              onTap: () {
                                if (wardDropdownValue == null) {
                                  setState(() {
                                    showWardDropdownError = true;
                                  });
                                  // return;
                                }
                                if (_formKey.currentState!.validate() &&
                                    !showWardDropdownError) {
                                  if (!showWardDropdownError) {
                                    FocusScope.of(context).unfocus();
                                    BlocProvider.of<UsersBloc>(context).add(
                                      EnrollAUserEvent(
                                        user: User(
                                          about: '',
                                          active: true,
                                          address:
                                              '${LocationMapField.addressLine1Controller.text}, ${LocationMapField.addressLine2Controller.text}',
                                          countryCode: '+91',
                                          staffId: AuthBasedRouting
                                              .afterLogin.userDetails!.staffID,
                                          createdDate:
                                              DateTime.now().toString(),
                                          emailId: emailController.text,
                                          firstName: firstNameController.text,
                                          lastModifiedDate:
                                              DateTime.now().toString(),
                                          lastName: lastNameController.text,
                                          mobileNumber:
                                              contactNumberController.text,
                                          municipalityId:
                                              authenticationSuccessState
                                                  .afterLogin
                                                  .userDetails!
                                                  .municipalityID,
                                          notificationToken: '',
                                          profilePicture: '',
                                          latitude: currentLocationState
                                              .latitude
                                              .toString(),
                                          longitude: currentLocationState
                                              .longitude
                                              .toString(),
                                          wardNumber: wards
                                              .firstWhere((element) =>
                                                  element.wardName ==
                                                  wardDropdownValue)
                                              .wardNumber,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  log('Not Working');
                                }
                              },
                              buttonText: LocaleKeys.enrollUsers_submit.tr(),
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
                          buttonText: LocaleKeys.enrollUsers_submit.tr(),
                        ),
                      );
                    },
                  ),
                );
              }
              return Align(
                alignment: Alignment.bottomRight,
                child: PrimaryButton(
                  enabled: false,
                  isLoading: false,
                  onTap: () {},
                  buttonText: LocaleKeys.enrollUsers_submit.tr(),
                ),
              );
            },
          ),
          SizedBox(
            height: 50.h,
          ),
        ],
      ),
    );
  }

  String? validateWardNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_wardDropdownError.tr();
    }
    return null;
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_firstNameValidationErrorMessage.tr();
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_lastNameValidaitonErrorMessage.tr();
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editUserDetails_addressRequiredMessage.tr();
    }
    return null;
  }

  String? validateCountry(String value) {
    if (value.isEmpty) {
      return LocaleKeys.editUserDetails_countryRequiredMessage.tr();
    }
    return null;
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_mobileNumberRequiredErrorMessage.tr();
    }
    if (value.length != 10) {
      return LocaleKeys.enrollUsers_mobileNumberLengthErrorMessage.tr();
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return LocaleKeys.enrollUsers_mobileNumberTypeErrorMessage.tr();
    }
    return null;
  }

  String? validateEmailAddress(String value) {
    // if (value.isEmpty) {
    //   return 'Email is required';
    // }
    return null;
  }
}
