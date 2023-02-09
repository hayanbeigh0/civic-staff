import 'dart:async';

import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/primary_top_shape.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GrievanceMap extends StatefulWidget {
  static const routeName = 'grievanceMap';
  const GrievanceMap({super.key});

  @override
  State<GrievanceMap> createState() => _GrievanceMapState();
}

class _GrievanceMapState extends State<GrievanceMap> {
  final Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor busLocationMarker = BitmapDescriptor.defaultMarker;

  Set<Marker> grievanceMarkers = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GrievancesBloc>(context).add(LoadGrievancesEvent());
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<GrievancesBloc, GrievancesState>(
            listener: (context, state) {
              if (state is GrievancesLoadedState) {
                grievanceMarkers = state.grievanceList
                    .map(
                      (e) => Marker(
                        markerId: MarkerId(e.grievanceId.toString()),
                        infoWindow: InfoWindow(
                          snippet: 'Status: ${e.status}',
                          title: e.grievanceType,
                          onTap: () => Navigator.of(context).pushNamed(
                            GrievanceDetail.routeName,
                            arguments: {
                              "state": state,
                              "index": state.grievanceList.indexOf(e),
                            },
                          ),
                        ),
                        icon: e.grievanceType.toString().toLowerCase().replaceAll(' ', '') ==
                                'garbagecollection'
                            ? BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRose,
                              )
                            : e.grievanceType
                                        .toString()
                                        .toLowerCase()
                                        .replaceAll(' ', '') ==
                                    'streetlighting'
                                ? BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue,
                                  )
                                : e.grievanceType
                                            .toString()
                                            .toLowerCase()
                                            .replaceAll(' ', '') ==
                                        'construction'
                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueGreen,
                                      )
                                    : e.grievanceType
                                                .toString()
                                                .toLowerCase()
                                                .replaceAll(' ', '') ==
                                            'watersupply/drainage'
                                        ? BitmapDescriptor.defaultMarkerWithHue(
                                            BitmapDescriptor.hueYellow,
                                          )
                                        : e.grievanceType
                                                    .toString()
                                                    .toLowerCase()
                                                    .replaceAll(' ', '') ==
                                                'certificaterequest'
                                            ? BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                BitmapDescriptor.hueCyan,
                                              )
                                            : e.grievanceType
                                                        .toString()
                                                        .toLowerCase()
                                                        .replaceAll(' ', '') ==
                                                    'houseplanapproval'
                                                ? BitmapDescriptor
                                                    .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueOrange,
                                                  )
                                                : e.grievanceType
                                                            .toString()
                                                            .toLowerCase()
                                                            .replaceAll(' ', '') ==
                                                        'roadmaintainance'
                                                    ? BitmapDescriptor.defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueViolet,
                                                      )
                                                    : BitmapDescriptor.defaultMarkerWithHue(
                                                        BitmapDescriptor
                                                            .hueViolet,
                                                      ),
                        position: LatLng(
                          double.parse(e.latitude.toString()),
                          double.parse(e.longitude.toString()),
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
                  padding: EdgeInsets.only(top: 100.h),
                  markers: grievanceMarkers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(
                        state.grievanceList.first.latitude.toString(),
                      ),
                      double.parse(
                        state.grievanceList.first.longitude.toString(),
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
                    if (mounted) {
                      _mapController.complete(controller);
                    }
                  },
                  mapType: MapType.terrain,
                );
              }
              return const SizedBox();
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
                  horizontal: 18.0.w,
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
                            'Map',
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
