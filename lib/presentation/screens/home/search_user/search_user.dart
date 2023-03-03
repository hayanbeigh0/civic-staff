import 'dart:developer';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/presentation/screens/home/search_user/user_details.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class SearchUser extends StatefulWidget {
  static const routeName = '/searchUser';
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController _searchController = TextEditingController();

  int? _selectedRadio;
  late String selectedFilter;
  int? selectedFilterNumber = 1;
  FocusNode searchNode = FocusNode();

  @override
  void initState() {
    _selectedRadio = 1;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchNode);
    });
    BlocProvider.of<UsersBloc>(context).add(const LoadAllUsersEvent(1));
    super.initState();
  }

  setSelectedRadio(int value) {
    setState(() {
      _selectedRadio = value;
    });
  }

  setFilter() {
    if (selectedFilterNumber == 1) {
      selectedFilter = 'Name';
    }
    if (selectedFilterNumber == 2) {
      selectedFilter = 'Mobile Number';
    }
    if (selectedFilterNumber == 3) {
      selectedFilter = 'Street Name';
    }
  }

  String getFilterName(int selectedFilterNumber) {
    if (selectedFilterNumber == 1) {
      return selectedFilter = 'Name';
    }
    if (selectedFilterNumber == 2) {
      return selectedFilter = 'Mobile Number';
    }
    if (selectedFilterNumber == 3) {
      return selectedFilter = 'Street Name';
    }
    return 'Name';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: Column(
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
                        Text(
                          LocaleKeys.searchUsers_screenTitle.tr(),
                          style: AppStyles.screenTitleStyle,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppColors.colorWhite,
                            size: 28.sp,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextField(
                    focusNode: searchNode,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return BlocProvider.of<UsersBloc>(context).add(
                          LoadAllUsersEvent(
                            int.parse(selectedFilterNumber.toString()),
                          ),
                        );
                      }
                      if (selectedFilterNumber == 1) {
                        BlocProvider.of<UsersBloc>(context).add(
                          SearchUserByNameEvent(
                            name: _searchController.text,
                            municipalityId: AuthBasedRouting
                                .afterLogin.userDetails!.municipalityID
                                .toString(),
                          ),
                        );
                      }
                      if (selectedFilterNumber == 2) {
                        BlocProvider.of<UsersBloc>(context).add(
                          SearchUserByMobileEvent(
                            mobileNumber: _searchController.text,
                          ),
                        );
                      }
                      if (selectedFilterNumber == 3) {
                        BlocProvider.of<UsersBloc>(context).add(
                          SearchUserByStreetEvent(
                            streetName: _searchController.text,
                          ),
                        );
                      }
                    },
                    controller: _searchController,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.colorPrimaryExtraLight,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 10.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide.none,
                      ),
                      hintText: LocaleKeys.searchUsers_searchFieldHint.tr(),
                      hintStyle: AppStyles.searchHintStyle,
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.sp,
                          horizontal: 20.sp,
                        ),
                        child: InkWell(
                          onTap: () => _showInnerBottomSheet(context),
                          child: SvgPicture.asset(
                            'assets/svg/filtericon.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 75.h,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersBloc, SearchUsersState>(
              builder: (context, state) {
                if (state is LoadingUsersFailedState) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenPadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.searchUsers_resultsBasedOn.tr()} ${getFilterName(state.selectedFilterNumber)}',
                                  style: AppStyles.listOrderedByTextStyle,
                                ),
                                const Spacer(),
                              ],
                            ),
                            const Divider(
                              color: AppColors.colorGreyLight,
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: Text('Unable to find the user!'),
                      ),
                    ],
                  );
                }
                if (state is SearchingUsersState) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenPadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.searchUsers_resultsBasedOn.tr()} ${getFilterName(state.selectedFilterNumber)}',
                                  style: AppStyles.listOrderedByTextStyle,
                                ),
                                const Spacer(),
                              ],
                            ),
                            const Divider(
                              color: AppColors.colorGreyLight,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Shimmer.fromColors(
                          baseColor: AppColors.colorPrimary200,
                          highlightColor: AppColors.colorPrimaryExtraLight,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 15.h,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: AppConstants.screenPadding,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.cardColorLight,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: AppColors.cardShadowColor,
                                    ),
                                    BoxShadow(
                                      offset: Offset(-2, -2),
                                      blurRadius: 4,
                                      color: AppColors.colorWhite,
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    CircleAvatar(
                                      radius: 36.w,
                                      backgroundColor: AppColors.colorPrimary,
                                      child: CircleAvatar(
                                        radius: 35.w,
                                        backgroundColor: const Color.fromARGB(
                                            255, 234, 234, 234),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '',
                                            maxLines: 1,
                                            style: AppStyles
                                                .userCardTitleTextStyle,
                                          ),
                                          Text(
                                            '',
                                            maxLines: 1,
                                            style: AppStyles.userCardTextStyle,
                                          ),
                                          Text(
                                            '',
                                            maxLines: 1,
                                            style: AppStyles.userCardTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: Container(
                                        padding: EdgeInsets.all(14.sp),
                                        decoration: const BoxDecoration(
                                          color: AppColors.colorPrimaryLight,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                              color: AppColors.cardShadowColor,
                                            ),
                                            BoxShadow(
                                              offset: Offset(-2, -2),
                                              blurRadius: 4,
                                              color: AppColors.colorWhite,
                                            ),
                                          ],
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/arrowright.svg',
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is LoadedUsersState) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstants.screenPadding,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.searchUsers_resultsBasedOn.tr()} ${getFilterName(state.selectedFilterNumber)}',
                                  style: AppStyles.listOrderedByTextStyle,
                                ),
                                const Spacer(),
                              ],
                            ),
                            const Divider(
                              color: AppColors.colorGreyLight,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          itemCount: state.userList.length,
                          itemBuilder: (context, index) {
                            return userInfoCard(state, index);
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.screenPadding,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${LocaleKeys.searchUsers_resultsBasedOn.tr()} ${getFilterName(
                                  int.parse(
                                    selectedFilterNumber.toString(),
                                  ),
                                )}',
                                style: AppStyles.listOrderedByTextStyle,
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Divider(
                            color: AppColors.colorGreyLight,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${LocaleKeys.searchUsers_startByTypingA.tr()} ${getFilterName(
                                int.parse(
                                  selectedFilterNumber.toString(),
                                ),
                              )}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(
                              height: 80.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector userInfoCard(LoadedUsersState state, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(UserDetails.routeName, arguments: {
          'user': state.userList[index],
        }).then((_) {
          if (selectedFilterNumber == 1) {
            BlocProvider.of<UsersBloc>(context).add(
              SearchUserByNameEvent(
                name: _searchController.text,
                municipalityId: AuthBasedRouting
                    .afterLogin.userDetails!.municipalityID
                    .toString(),
              ),
            );
          }
          if (selectedFilterNumber == 2) {
            BlocProvider.of<UsersBloc>(context).add(
              SearchUserByMobileEvent(
                mobileNumber: _searchController.text,
              ),
            );
          }
          if (selectedFilterNumber == 3) {
            BlocProvider.of<UsersBloc>(context).add(
              SearchUserByStreetEvent(
                streetName: _searchController.text,
              ),
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 15.h,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.screenPadding,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardColorLight,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: AppColors.cardShadowColor,
            ),
            BoxShadow(
              offset: Offset(-2, -2),
              blurRadius: 4,
              color: AppColors.colorWhite,
            ),
          ],
        ),
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            CircleAvatar(
              radius: 36.w,
              backgroundColor: AppColors.colorPrimary,
              child: CircleAvatar(
                radius: 35.w,
                backgroundColor: const Color.fromARGB(255, 234, 234, 234),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.userList[index].firstName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.userCardTitleTextStyle,
                  ),
                  Text(
                    '${LocaleKeys.userDetails_location.tr()} - ${state.userList[index].address}',
                    maxLines: 1,
                    style: AppStyles.userCardTextStyle,
                  ),
                  Text(
                    '${LocaleKeys.userDetails_mobile.tr()} - ${state.userList[index].mobileNumber}',
                    maxLines: 1,
                    style: AppStyles.userCardTextStyle,
                  ),
                  Text(
                    state.userList[index].active! ? '' : '(User Disabled)',
                    maxLines: 1,
                    style:
                        AppStyles.userCardTextStyle.copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Container(
                padding: EdgeInsets.all(14.sp),
                decoration: const BoxDecoration(
                  color: AppColors.colorPrimaryLight,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: AppColors.cardShadowColor,
                    ),
                    BoxShadow(
                      offset: Offset(-2, -2),
                      blurRadius: 4,
                      color: AppColors.colorWhite,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/arrowright.svg',
                  color: AppColors.colorPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInnerBottomSheet(
    BuildContext context,
  ) {
    _selectedRadio = selectedFilterNumber;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext innerContext) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.sp),
                topRight: Radius.circular(20.sp),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Divider(
                    height: 30.h,
                    thickness: 2,
                    color: AppColors.colorPrimaryDark,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${LocaleKeys.searchUsers_filterBy.tr()}:',
                        style: AppStyles.screenTitleStyle.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor: AppColors.colorPrimary,
                              value: 1,
                              groupValue: _selectedRadio,
                              onChanged: (value) {
                                setModalState(() {
                                  setSelectedRadio(int.parse(value.toString()));
                                });
                              }),
                          Text(
                            LocaleKeys.searchUsers_name.tr(),
                            style: TextStyle(
                              color: AppColors.colorPrimaryDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor: AppColors.colorPrimary,
                              value: 2,
                              groupValue: _selectedRadio,
                              onChanged: (value) {
                                setModalState(() {
                                  setSelectedRadio(int.parse(value.toString()));
                                });
                              }),
                          Text(
                            LocaleKeys.searchUsers_mobileNumber.tr(),
                            style: AppStyles.searchHintStyle.copyWith(
                              color: AppColors.colorPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                              activeColor: AppColors.colorPrimary,
                              value: 3,
                              groupValue: _selectedRadio,
                              onChanged: (value) {
                                setModalState(() {
                                  setSelectedRadio(int.parse(value.toString()));
                                });
                              }),
                          Text(
                            LocaleKeys.searchUsers_streetName.tr(),
                            style: TextStyle(
                              color: AppColors.colorPrimaryDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: PrimaryButton(
                          onTap: () {
                            selectedFilterNumber = _selectedRadio;
                            if (selectedFilterNumber == 1) {
                              BlocProvider.of<UsersBloc>(context)
                                  .add(SearchUserByNameEvent(
                                name: _searchController.text,
                                municipalityId: AuthBasedRouting
                                    .afterLogin.userDetails!.municipalityID
                                    .toString(),
                              ));
                              BlocProvider.of<UsersBloc>(context)
                                  .add(const LoadAllUsersEvent(1));
                            }
                            if (selectedFilterNumber == 2) {
                              BlocProvider.of<UsersBloc>(context)
                                  .add(SearchUserByMobileEvent(
                                mobileNumber: _searchController.text,
                              ));
                              BlocProvider.of<UsersBloc>(context)
                                  .add(const LoadAllUsersEvent(1));
                            }
                            if (selectedFilterNumber == 3) {
                              BlocProvider.of<UsersBloc>(context)
                                  .add(SearchUserByStreetEvent(
                                streetName: _searchController.text,
                              ));
                              BlocProvider.of<UsersBloc>(context)
                                  .add(const LoadAllUsersEvent(1));
                            }
                            Navigator.of(context).pop();
                          },
                          buttonText: LocaleKeys.searchUsers_apply.tr(),
                          isLoading: false,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.sp),
          topRight: Radius.circular(30.sp),
        ),
      ),
    );
  }
}
