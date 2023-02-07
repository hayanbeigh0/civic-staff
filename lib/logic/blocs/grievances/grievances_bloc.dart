import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/resources/repositories/grievances/grievances_repository.dart';
import 'package:equatable/equatable.dart';

part 'grievances_event.dart';
part 'grievances_state.dart';

class GrievancesBloc extends Bloc<GrievancesEvent, GrievancesState> {
  final GrievancesRepository grievancesRepository;
  List<Grievances> grievanceList = [];
  GrievancesBloc(this.grievancesRepository) : super(GrievancesLoadingState()) {
    on<GrievancesEvent>((event, emit) {});

    on<LoadGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      try {
        grievanceList = await grievancesRepository.loadGrievancesJson();
        emit(
          GrievancesMarkersLoadedState(grievanceList: grievanceList),
        );
        emit(GrievancesLoadedState(
          grievanceList: grievanceList,
        ));
      } catch (e) {
        emit(GrievancesLoadingFailedState());
      }
    });

    on<CloseGrievanceEvent>((event, emit) async {
      emit(ClosingGrievanceState());
      grievanceList =
          await grievancesRepository.closeGrievance(event.grievanceId);
      emit(GrievanceClosedState());
      add(LoadGrievancesEvent());
    });

    on<UpdateGrievanceStatusEvent>((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      final Grievances grievance =
          await grievancesRepository.updateGrievanceStatus(
        event.grievanceId,
        event.status,
      );
      emit(GrievanceUpdatedState(grievance: grievance));
    });
  }
}
