import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryDropdown extends StatefulWidget {
  PrimaryDropdown({
    super.key,
    required this.dropdownList,
    this.showDropdownError = false,
    required this.dropdownValue,
    // required this.validator,
  });
  bool showDropdownError;
  final List<String> dropdownList;
  String? dropdownValue;
  // Function validator;

  @override
  State<PrimaryDropdown> createState() => _PrimaryDropdownState();
}

class _PrimaryDropdownState extends State<PrimaryDropdown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              widget.dropdownValue.toString(),
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
            items: widget.dropdownList
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
              widget.dropdownValue = value.toString();
              setState(() {
                widget.showDropdownError = false;
              });
            },
            // validator: (value) => widget.validator(),
            validator: (value) => validateDropdown(
              value.toString(),
            ),
          ),
        ),
        widget.showDropdownError
            ? Column(
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Please select a value',
                    style: AppStyles.errorTextStyle,
                  )
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  String? validateDropdown(String value) {
    if (value.isEmpty) {
      return LocaleKeys.enrollUsers_wardDropdownError.tr();
    }
    return null;
  }
}
