import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/presentation/screens/home/search_user/user_details.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/primary_button.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchUser extends StatefulWidget {
  static const routeName = '/searchUser';
  SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController _searchController = TextEditingController();

  int? _selectedRadio;
  late String selectedFilter;
  int? selectedFilterNumber = 1;

  @override
  void initState() {
    _selectedRadio = 1;
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
            height: 230.h,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 18.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        Text(
                          'Search Users',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontFamily: 'LexendDeca',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextField(
                    onChanged: (value) {
                      if (selectedFilterNumber == 1) {
                        BlocProvider.of<UsersBloc>(context).add(
                          SearchUserByNameEvent(
                            name: _searchController.text,
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
                        vertical: 0.sp,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: AppColors.textColorLight,
                        fontFamily: 'LexendDeca',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.1,
                      ),
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: BlocBuilder<UsersBloc, SearchUsersState>(
                builder: (context, state) {
                  if (state is LoadedUsersState) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Results based on ${getFilterName(state.selectedFilterNumber)}',
                              style: TextStyle(
                                color: AppColors.colorGreyLight,
                                fontFamily: 'LexendDeca',
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const Divider(
                          color: AppColors.colorGreyLight,
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
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container userInfoCard(LoadedUsersState state, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 15.h,
      ),
      margin: EdgeInsets.symmetric(
        // horizontal: 18.w,
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
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                    fontFamily: 'LexendDeca',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Location - ${state.userList[index].city}',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                    fontFamily: 'LexendDeca',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Mobile - ${state.userList[index].mobileNumber}',
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.cardTextColor,
                    fontFamily: 'LexendDeca',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: InkWell(
              borderRadius: BorderRadius.circular(100.r),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(UserDetails.routeName, arguments: {
                  'user': state.userList[index],
                });
              },
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
          ),
        ],
      ),
    );
  }

  void _showInnerBottomSheet(BuildContext context) {
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
                        'Filter by:',
                        style: TextStyle(
                          color: AppColors.colorPrimaryDark,
                          fontFamily: 'LexendDeca',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
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
                                  setSelectedRadio(value!.toInt());
                                });
                              }),
                          Text(
                            "Name",
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
                                  setSelectedRadio(value!.toInt());
                                });
                              }),
                          Text(
                            "Mobile number",
                            style: TextStyle(
                              color: AppColors.colorPrimaryDark,
                              fontFamily: 'LexendDeca',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.1,
                            ),
                          )
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
                                  setSelectedRadio(value!.toInt());
                                });
                              }),
                          Text(
                            "Street name",
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
                              ));
                            }
                            if (selectedFilterNumber == 2) {
                              BlocProvider.of<UsersBloc>(context)
                                  .add(SearchUserByMobileEvent(
                                mobileNumber: _searchController.text,
                              ));
                            }
                            if (selectedFilterNumber == 3) {
                              BlocProvider.of<UsersBloc>(context)
                                  .add(SearchUserByStreetEvent(
                                streetName: _searchController.text,
                              ));
                            }
                            Navigator.of(context).pop();
                          },
                          buttonText: 'Apply',
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
