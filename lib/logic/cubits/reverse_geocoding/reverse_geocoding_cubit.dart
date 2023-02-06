import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';

part 'reverse_geocoding_state.dart';

class ReverseGeocodingCubit extends Cubit<ReverseGeocodingState> {
  ReverseGeocodingCubit() : super(ReverseGeocodingLoading());
  List<Placemark> placemarks = [];
  Future<void> loadReverseGeocodedAddress(
    double latitude,
    double longitude,
  ) async {
    emit(ReverseGeocodingLoading());
    placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    emit(
      ReverseGeocodingLoaded(
        countryName: placemarks[0].country.toString(),
        name: placemarks[0].name.toString(),
        street: placemarks[0].street.toString(),
        locality: placemarks[0].locality.toString(),
      ),
    );
  }
}
