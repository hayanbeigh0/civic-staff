// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesState extends Equatable {
  const GrievancesState();
}

class GrievancesLoadingState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class GrievancesLoadedState extends GrievancesState {
  final List<Grievances> grievanceList;
  const GrievancesLoadedState({
    required this.grievanceList,
  });
  @override
  List<Object?> get props => [grievanceList];
}

class GrievancesMarkersLoadedState extends GrievancesState {
  final List<Grievances> grievanceList;
  const GrievancesMarkersLoadedState({
    required this.grievanceList,
  });
  @override
  List<Object?> get props => [grievanceList];
}

class GrievancesLoadingFailedState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class UpdatingGrievanceStatusState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class UpdatingGrievanceStatusFailedState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class GrievanceUpdatedState extends GrievancesState {
  final Grievances grievance;
  const GrievanceUpdatedState({
    required this.grievance,
  });
  @override
  List<Object?> get props => [grievance];
}

class ClosingGrievanceState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class GrievanceClosedState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class ClosingGrievanceFailedState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

// § GrievancesLoadingState

// § GrievancesLoadedState

// § GrievancesLoadingFailedState

// § UpdatingGrievanceStatusState

// § UpdatingGrievanceStatusFailedState

// § GrievanceUpdatedState

// § ClosingGrievanceState

// § GrievanceClosedState

// § ClosingGrievanceFailedState