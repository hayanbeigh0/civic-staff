import 'dart:async';
import 'dart:developer';

import 'package:civic_staff/presentation/utils/functions/location_permissions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

part 'current_location_state.dart';

class CurrentLocationCubit extends Cubit<CurrentLocationState> {
  late double latitude;
  late double longitude;
  late Position position;
  late StreamSubscription locationStream;
  CurrentLocationCubit() : super(CurrentLocationLoading());

  getCurrentLocation() async {
    if (await checkLocationPermissions()) {
      locationStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      ).listen((event) {
        log(event.latitude.toString());
        emit(
          CurrentLocationLoaded(
            latitude: event.latitude,
            longitude: event.longitude,
          ),
        );
      });
    }
  }

  @override
  Future<void> close() {
    locationStream.cancel();
    return super.close();
  }
}
