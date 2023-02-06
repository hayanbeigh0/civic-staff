// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reverse_geocoding_cubit.dart';

abstract class ReverseGeocodingState extends Equatable {
  const ReverseGeocodingState();
}

class ReverseGeocodingLoading extends ReverseGeocodingState {
  @override
  List<Object?> get props => [];
}

class ReverseGeocodingLoaded extends ReverseGeocodingState {
  final String name;
  final String countryName;
  final String locality;
  final String street;
  const ReverseGeocodingLoaded({
    required this.name,
    required this.countryName,
    required this.locality,
    required this.street,
  });

  @override
  List<Object?> get props => [name, countryName, street, locality];
}

class ReverseGeocodingLoadingError extends ReverseGeocodingState {
  @override
  List<Object?> get props => [];
}
