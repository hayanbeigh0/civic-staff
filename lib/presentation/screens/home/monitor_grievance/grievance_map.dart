import 'dart:async';

import 'package:civic_staff/constants/app_constants.dart';
import 'package:civic_staff/generated/locale_keys.g.dart';
import 'package:civic_staff/main.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/utils/styles/app_styles.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GrievanceMap extends StatelessWidget {
  static const routeName = 'grievanceMap';
  GrievanceMap({super.key});

  final Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor busLocationMarker = BitmapDescriptor.defaultMarker;

  Set<Marker> grievanceMarkers = {};
  final Map<String, String> grievanceTypesMap = {
    "garb": 'Garbage Collection',
    "road": 'Road maintenance / Construction',
    "light": 'Street Lighting',
    "cert": 'Certificate Request',
    "house": 'House plan approval',
    "water": 'Water supply / drainage',
    "elect": 'Electricity',
    "other": 'Other',
  };

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GrievancesBloc>(context).add(
      LoadGrievancesEvent(
        staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
        municipalityId:
            AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<GrievancesBloc, GrievancesState>(
            listener: (context, state) {
              if (state is GrievancesLoadedState) {
                grievanceMarkers = state.grievanceList
                    .mapIndexed(
                      (i, e) => Marker(
                        markerId: MarkerId(e.grievanceID.toString()),
                        infoWindow: InfoWindow(
                          snippet:
                              'Status: ${AuthBasedRouting.afterLogin.masterData!.firstWhere((element) => element.pK == '#GRIEVANCESTATUS#' && element.sK == e.status).name}',
                          title:
                              grievanceTypesMap[e.grievanceType!.toLowerCase()],
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              GrievanceDetail.routeName,
                              arguments: {
                                "grievanceId":
                                    state.grievanceList[i].grievanceID,
                              },
                            );
                          },
                        ),
                        icon: e.grievanceType.toString().toLowerCase().replaceAll(' ', '') ==
                                'garb'
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRose,
                              )
                            : e.grievanceType
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '') ==
                                    'light'
                                ? BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue,
                                  )
                                : e.grievanceType
                                            .toString()
                                            .toLowerCase()
                                            .replaceAll(' ', '') ==
                                        'road'
                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueGreen,
                                      )
                                    : e.grievanceType
                                                .toString()
                                                .toLowerCase()
                                                .replaceAll(' ', '') ==
                                            'water'
                                        ? BitmapDescriptor.defaultMarkerWithHue(
                                            BitmapDescriptor.hueYellow,
                                          )
                                        : e.grievanceType
                                                    .toString()
                                                    .toLowerCase()
                                                    .replaceAll(' ', '') ==
                                                'cert'
                                            ? BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                BitmapDescriptor.hueCyan,
                                              )
                                            : e.grievanceType
                                                        .toString()
                                                        .toLowerCase()
                                                        .replaceAll(' ', '') ==
                                                    'house'
                                                ? BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueOrange,
                                                  )
                                                : e.grievanceType
                                                            .toString()
                                                            .toLowerCase()
                                                            .replaceAll(' ', '') ==
                                                        'other'
                                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueViolet,
                                                      )
                                                    : e.grievanceType.toString().toLowerCase().replaceAll(' ', '') == 'elect'
                                                        ? BitmapDescriptor.defaultMarkerWithHue(
                                                            BitmapDescriptor
                                                                .hueMagenta,
                                                          )
                                                        : BitmapDescriptor.defaultMarkerWithHue(
                                                            BitmapDescriptor
                                                                .hueViolet,
                                                          ),
                        position: LatLng(
                          double.parse(e.locationLat.toString()),
                          double.parse(e.locationLong.toString()),
                        ),
                      ),
                    )
                    .toList()
                    .toSet();
              }
            },
            builder: (context, state) {
              if (state is GrievancesLoadedState) {
                return GoogleMap(
                  compassEnabled: true,
                  padding: EdgeInsets.only(top: 120.h),
                  markers: grievanceMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(
                        state.grievanceList.first.locationLat.toString(),
                      ),
                      double.parse(
                        state.grievanceList.first.locationLong.toString(),
                      ),
                    ),
                    zoom: 12,
                  ),
                  zoomControlsEnabled: true,
                  scrollGesturesEnabled: true,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) async {
                    // if (mounted) {
                    _mapController.complete(controller);
                    // }
                  },
                  mapType: MapType.terrain,
                );
              }
              return const CircularProgressIndicator(
                color: AppColors.colorPrimary,
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: PrimaryTopShape(
              child: Container(
                alignment: Alignment.topCenter,
                height: 141.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenPadding,
                  vertical: 0,
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
                            radius: 30,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.sp),
                              color: Colors.transparent,
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
                                    LocaleKeys.map_screenTitle.tr(),
                                    style: AppStyles.screenTitleStyle,
                                  ),
                                ],
                              ),
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
          ),
        ],
      ),
    );
  }
  // void _currentLocation() async {
  //  final GoogleMapController controller = await _controller.future;
  //  LocationData currentLocation;
  //  var location = new Location();
  //  try {
  //    currentLocation = await location.getLocation();
  //    } on Exception {
  //      currentLocation = null;
  //      }

  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       bearing: 0,
  //       target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       zoom: 17.0,
  //     ),
  //   ));
  // }
}
