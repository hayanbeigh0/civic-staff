// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesEvent extends Equatable {
  const GrievancesEvent();
}

class LoadGrievancesEvent extends GrievancesEvent {
  @override
  List<Object> get props => [];
}

// class GetGrievancesEvent extends GrievancesEvent {
//   @override
//   List<Object> get props => [];
// }

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

class UpdateGrievanceEvent extends GrievancesEvent {
  final Grievances newGrievance;
  final String grievanceId;
  const UpdateGrievanceEvent({
    required this.grievanceId,
    required this.newGrievance,
  });
  @override
  List<Object> get props => [grievanceId, newGrievance];
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
