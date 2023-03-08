// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesState extends Equatable {
  const GrievancesState();
}

class GrievancesLoadingState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class NoGrievanceFoundState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class GrievancesLoadedState extends GrievancesState {
  final List<Grievances> grievanceList;
  final int selectedFilterNumber;
  const GrievancesLoadedState({
    required this.grievanceList,
    required this.selectedFilterNumber,
  });
  // GrievancesLoadedState copyWith({required List<Grievances> grievanceList}) {
  //   return GrievancesLoadedState(grievanceList: this.grievanceList, );
  // }

  @override
  List<Object?> get props => [grievanceList, selectedFilterNumber];
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

class UpdatingExpectedCompletionState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class UpdatingGrievanceStatusFailedState extends GrievancesState {
  @override
  List<Object?> get props => [];
}

class GrievanceUpdatedState extends GrievancesState {
  final bool grievanceUpdated;
  const GrievanceUpdatedState({
    required this.grievanceUpdated,
  });
  @override
  List<Object?> get props => [grievanceUpdated];
}

class ExpectedCompletionUpdatedState extends GrievancesState {
  final bool expectedCompletionUpdated;
  const ExpectedCompletionUpdatedState({
    required this.expectedCompletionUpdated,
  });
  @override
  List<Object?> get props => [expectedCompletionUpdated];
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

class LoadingGrievanceByIdState extends GrievancesState {
  @override
  List<Object> get props => [];
}

class LoadingGrievanceByIdFailedState extends GrievancesState {
  @override
  List<Object> get props => [];
}

class GrievanceByIdLoadedState extends GrievancesState {
  final GrievanceDetail grievanceDetail;
  const GrievanceByIdLoadedState({required this.grievanceDetail});
  @override
  List<Object> get props => [grievanceDetail];
}

class AddingGrievanceCommentFailedState extends GrievancesState {
  @override
  List<Object> get props => [];
}

class AddingGrievanceCommentState extends GrievancesState {
  @override
  List<Object> get props => [];
}

class AddingGrievanceCommentSuccessState extends GrievancesState {
  @override
  List<Object> get props => [];
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