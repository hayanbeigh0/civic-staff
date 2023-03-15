import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/asset_video_thumbnail.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:civic_staff/presentation/widgets/video_asset_widget.dart';
import 'package:civic_staff/presentation/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrievancePhotoVideo extends StatelessWidget {
  static const routeName = '/grievancePhotoVideo';
  const GrievancePhotoVideo({
    super.key,
    required this.state,
    required this.grievanceListIndex,
  });
  final GrievanceByIdLoadedState state;
  final int grievanceListIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<GrievancesBloc>(context).add(GetGrievanceByIdEvent(
            municipalityId:
                AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
            grievanceId: state.grievanceDetail.grievanceID!,
          ));
          return true;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    LocaleKeys.grievanceDetail_photosAndVideos
                                        .tr(),
                                    style: AppStyles.screenTitleStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                  vertical: 10.h,
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 30.w,
                    mainAxisSpacing: 20.h,
                  ),
                  itemCount:
                      state.grievanceDetail.assets!.image!.length.toInt() +
                          state.grievanceDetail.assets!.video!.length.toInt(),
                  itemBuilder: (context, index) {
                    if (index <
                        state.grievanceDetail.assets!.image!.length.toInt()) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimaryExtraLight,
                          borderRadius: BorderRadius.circular(
                            20.r,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.all(0.sp),
                                  content: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Image.network(
                                      state.grievanceDetail.assets!
                                          .image![index],
                                      cacheHeight: 700,
                                      cacheWidth: 700,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Image.network(
                            state.grievanceDetail.assets!.image![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.colorPrimaryExtraLight,
                          borderRadius: BorderRadius.circular(
                            20.r,
                          ),
                        ),
                        child:
                            // Stack(
                            //   children: [
                            //     VideoAssetWidget(
                            //       url: state.grievanceDetail.assets!.video![index -
                            //           state.grievanceDetail.assets!.image!.length],
                            //     ),
                            //   ],
                            // ),
                            Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FullScreenVideoPlayer(
                                    url: state.grievanceDetail.assets!.video![
                                        index -
                                            state.grievanceDetail.assets!.image!
                                                .length],
                                    file: null,
                                  ),
                                ));
                              },
                              child: Container(
                                width: 200.w,
                                height: 150.h,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                      color: AppColors.cardShadowColor,
                                    ),
                                    BoxShadow(
                                      blurRadius: 2,
                                      offset: Offset(-1, -1),
                                      color: AppColors.colorWhite,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: AppColors.colorPrimaryLight,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AssetVideoThumbnail(
                                      url: state.grievanceDetail.assets!.video![
                                          index -
                                              state.grievanceDetail.assets!
                                                  .image!.length],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: PrimaryBottomShape(
      //   height: 80.h,
      // ),
    );
  }
}
