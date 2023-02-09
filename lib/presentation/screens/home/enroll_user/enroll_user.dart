import 'dart:async';
import 'dart:developer';

import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/functions/popups.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/location_map_field.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_text_field.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
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

  final List<String> wards = ['Ward 12', 'Ward 13', 'Ward 14', 'Ward 15'];

  String? dropdownValue;

  bool showDropdownError = false;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CurrentLocationCubit>(context).getCurrentLocation();
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
                          child: SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            color: AppColors.colorWhite,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Enroll User',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryTextField(
                        focusNode: firstNameNode,
                        fieldValidator: (p0) {
                          return validateFirstName(p0.toString());
                        },
                        title: 'First Name',
                        hintText: 'First Name',
                        textEditingController: firstNameController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryTextField(
                        fieldValidator: (p0) {
                          return validateLastName(p0.toString());
                        },
                        title: 'Last Name',
                        hintText: 'Last Name',
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
                        title: 'Contact Number',
                        hintText: '123-7281-927',
                        textEditingController: contactNumberController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      PrimaryTextField(
                        fieldValidator: (p0) => validateEmailAddress(
                          p0.toString(),
                        ),
                        title: 'Email',
                        hintText: 'you@example.com',
                        textEditingController: emailController,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        'Ward',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
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
                          isExpanded: true,
                          iconSize: 24.sp,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          hint: Text(
                            'Select Ward',
                            style: TextStyle(
                              overflow: TextOverflow.fade,
                              color: AppColors.textColorDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              overflow: TextOverflow.fade,
                              color: AppColors.textColorDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                            ),
                            border: InputBorder.none,
                          ),
                          items: wards
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    maxLines: 1,
                                    style: TextStyle(
                                      overflow: TextOverflow.fade,
                                      color: AppColors.textColorDark,
                                      fontFamily: 'LexendDeca',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w300,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            dropdownValue = value.toString();
                            setState(() {
                              showDropdownError = false;
                            });
                          },
                          validator: (value) => validateWardNumber(
                            value.toString(),
                          ),
                        ),
                      ),
                      showDropdownError
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  'Please select a value!',
                                  style: AppStyles.errorTextStyle,
                                )
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        'Location',
                        style: TextStyle(
                          color: AppColors.textColorDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
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
                                  gesturesEnabled: true,
                                  myLocationEnabled: true,
                                  zoomEnabled: true,
                                  mapController: _controller,
                                  latitude: state.latitude,
                                  longitude: state.longitude,
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
                          return SizedBox(
                            height: 180.h,
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
                              child: BlocBuilder<CurrentLocationCubit,
                                  CurrentLocationState>(
                                builder: (context, currentLocationState) {
                                  if (currentLocationState
                                      is CurrentLocationLoaded) {
                                    return BlocConsumer<UsersBloc,
                                        SearchUsersState>(
                                      listener: (context, userState) {
                                        if (userState is UserEnrolledState) {
                                          primaryPopupDialog(
                                            context: context,
                                            title: 'Success',
                                            buttonText: 'Ok',
                                            content: 'User has been added!',
                                            ontap: () =>
                                                Navigator.of(context).pop(),
                                          ).then(
                                            (value) => FocusScope.of(context)
                                                .requestFocus(firstNameNode),
                                          );

                                          firstNameController.text = '';
                                          lastNameController.text = '';
                                          emailController.text = '';
                                          contactNumberController.text = '';
                                          wardNumberController.text = '';
                                        }
                                      },
                                      builder: (context, userState) {
                                        if (userState is EnrollingAUserState) {
                                          return PrimaryButton(
                                            enabled: true,
                                            isLoading: true,
                                            onTap: () {},
                                            buttonText: 'Submit',
                                          );
                                        }
                                        return PrimaryButton(
                                          isLoading: false,
                                          onTap: () {
                                            log('hello');
                                            if (dropdownValue == null) {
                                              setState(() {
                                                showDropdownError = true;
                                              });
                                            }
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                !showDropdownError) {
                                              if (!showDropdownError) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                BlocProvider.of<UsersBloc>(
                                                        context)
                                                    .add(
                                                  EnrollAUserEvent(
                                                    user: User(
                                                      id: '2',
                                                      about: '',
                                                      city: state.name,
                                                      country:
                                                          state.countryName,
                                                      streetName: state.street,
                                                      mobileNumber:
                                                          contactNumberController
                                                              .text,
                                                      firstName:
                                                          firstNameController
                                                              .text,
                                                      lastName:
                                                          lastNameController
                                                              .text,
                                                      wardNumber: dropdownValue,
                                                      email:
                                                          emailController.text,
                                                      latitude:
                                                          currentLocationState
                                                              .latitude
                                                              .toString(),
                                                      longitude:
                                                          currentLocationState
                                                              .longitude
                                                              .toString(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {}
                                          },
                                          buttonText: 'Submit',
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
                                      buttonText: 'Submit',
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
                              buttonText: 'Submit',
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
      return 'Please select a value';
    }
    return null;
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return 'First name is required';
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return 'Last name is required';
    }
    return null;
  }

  String? validateMobileNumber(String value) {
    if (value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits long';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Mobile number can only contain digits';
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
