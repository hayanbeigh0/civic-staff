// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesEvent extends Equatable {
  const GrievancesEvent();
}

class LoadGrievancesEvent extends GrievancesEvent {
  @override
  List<Object> get props => [];
}

class CloseGrievanceEvent extends GrievancesEvent {
  final String grievanceId;
  const CloseGrievanceEvent({
    required this.grievanceId,
  });
  @override
  List<Object> get props => [grievanceId];
}

class UpdateGrievanceStatusEvent extends GrievancesEvent {
  final String status;
  final String grievanceId;
  const UpdateGrievanceStatusEvent({
    required this.grievanceId,
    required this.status,
  });
  @override
  List<Object> get props => [grievanceId, status];
}
