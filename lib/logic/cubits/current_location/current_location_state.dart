// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'current_location_cubit.dart';

abstract class CurrentLocationState extends Equatable {
  const CurrentLocationState();
}

class CurrentLocationLoading extends CurrentLocationState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class CurrentLocationLoaded extends CurrentLocationState {
  final double latitude;
  final double longitude;
  const CurrentLocationLoaded({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
