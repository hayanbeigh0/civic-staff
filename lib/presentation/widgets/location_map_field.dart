import 'dart:async';

import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/presentation/widgets/primary_display_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapField extends StatelessWidget {
  LocationMapField({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.mapController,
    this.zoomEnabled = false,
  });

  final double latitude;
  final double longitude;
  final Completer<GoogleMapController> mapController;
  late LatLng pickedLoc;
  final bool zoomEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: AppColors.colorPrimaryLight,
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  latitude,
                  longitude,
                ),
                zoom: 14.4746,
              ),
              zoomControlsEnabled: zoomEnabled,
              scrollGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) async {
                mapController.complete(controller);
                BlocProvider.of<ReverseGeocodingCubit>(context)
                    .loadReverseGeocodedAddress(
                  latitude,
                  longitude,
                );
              },
              onCameraIdle: () async {
                BlocProvider.of<ReverseGeocodingCubit>(context)
                    .loadReverseGeocodedAddress(
                  pickedLoc.latitude,
                  pickedLoc.longitude,
                );
              },
              onCameraMove: (position) async {
                pickedLoc = position.target;
              },
              mapType: MapType.terrain,
            ),
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        BlocBuilder<ReverseGeocodingCubit, ReverseGeocodingState>(
          builder: (context, state) {
            if (state is ReverseGeocodingLoaded) {
              return Column(
                children: [
                  PrimaryDisplayField(
                    title: '',
                    value: '${state.street}, ${state.locality}',
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  PrimaryDisplayField(
                    title: '',
                    value: state.countryName,
                  ),
                ],
              );
            }
            return Column(
              children: [
                const PrimaryDisplayField(title: '', value: ''),
                SizedBox(
                  height: 12.h,
                ),
                const PrimaryDisplayField(
                  title: '',
                  value: '',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
