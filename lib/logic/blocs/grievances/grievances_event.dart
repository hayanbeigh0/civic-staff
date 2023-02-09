// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesEvent extends Equatable {
  const GrievancesEvent();
}

class LoadGrievancesEvent extends GrievancesEvent {
  @override
  List<Object> get props => [];
}

class GetGrievancesEvent extends GrievancesEvent {
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

class SearchGrievanceByTypeEvent extends GrievancesEvent {
  final String grievanceType;
  const SearchGrievanceByTypeEvent({
    required this.grievanceType,
  });
  @override
  List<Object> get props => [grievanceType];
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

class UpdateExpectedCompletionEvent extends GrievancesEvent {
  final String expectedCompletion;
  final String grievanceId;
  const UpdateExpectedCompletionEvent({
    required this.grievanceId,
    required this.expectedCompletion,
  });
  @override
  List<Object> get props => [grievanceId, expectedCompletion];
}
