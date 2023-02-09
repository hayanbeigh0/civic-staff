import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/resources/repositories/grievances/grievances_repository.dart';
import 'package:equatable/equatable.dart';

part 'grievances_event.dart';
part 'grievances_state.dart';

class GrievancesBloc extends Bloc<GrievancesEvent, GrievancesState> {
  final GrievancesRepository grievancesRepository;
  // List<Grievances> grievanceList = [];
  GrievancesBloc(this.grievancesRepository) : super(GrievancesLoadingState()) {
    on<GrievancesEvent>((event, emit) {});
    on<GetGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      try {
        List<Grievances> grievanceList =
            await grievancesRepository.loadGrievancesJson();
        emit(
          GrievancesMarkersLoadedState(grievanceList: grievanceList),
        );
        emit(GrievancesLoadedState(
          grievanceList: grievanceList,
          selectedFilterNumber: 1,
        ));
        add(LoadGrievancesEvent());
      } catch (e) {
        emit(GrievancesLoadingFailedState());
      }
    });

    on<LoadGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      try {
        await Future.delayed(const Duration(seconds: 2));
        final List<Grievances> updatedGrievanceList =
            List.of(GrievancesRepository.grievanceList);
        updatedGrievanceList.sort((g1, g2) {
          DateTime timestamp1 = DateTime.parse(g1.timeStamp.toString());
          DateTime timestamp2 = DateTime.parse(g2.timeStamp.toString());
          return timestamp2.compareTo(timestamp1);
        });
        emit(
          GrievancesMarkersLoadedState(grievanceList: updatedGrievanceList),
        );
        emit(GrievancesLoadedState(
            grievanceList: updatedGrievanceList, selectedFilterNumber: 1));
      } catch (e) {
        emit(GrievancesLoadingFailedState());
      }
    });

    on<CloseGrievanceEvent>((event, emit) async {
      emit(ClosingGrievanceState());
      await grievancesRepository.closeGrievance(event.grievanceId);
      emit(GrievanceClosedState());
      add(LoadGrievancesEvent());
    });

    on<UpdateGrievanceStatusEvent>((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      await grievancesRepository.updateGrievanceStatus(
        event.grievanceId,
        event.status,
      );
      emit(const GrievanceUpdatedState(grievanceUpdated: true));
      add(LoadGrievancesEvent());
    });
    on<UpdateExpectedCompletionEvent>((event, emit) async {
      emit(UpdatingExpectedCompletionState());
      await grievancesRepository.updateExpectedCompletion(
        event.grievanceId,
        event.expectedCompletion,
      );
      emit(const GrievanceUpdatedState(grievanceUpdated: true));
      add(LoadGrievancesEvent());
    });
    on<SearchGrievanceByTypeEvent>((event, emit) {
      emit(GrievancesLoadingState());
      // userRepository.loadUserJson();
      final List<Grievances> updatedGrievanceList =
          GrievancesRepository.grievanceList
              .where(
                (element) => element.grievanceType!
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .startsWith(
                      event.grievanceType.toLowerCase().replaceAll(' ', ''),
                    ),
              )
              .toList();
      updatedGrievanceList.sort();
      emit(
        GrievancesLoadedState(
          grievanceList: updatedGrievanceList,
          selectedFilterNumber: 1,
        ),
      );
    });
    // on<SearchUserByMobileEvent>((event, emit) {
    //   // userRepository.loadUserJson();
    //   emit(SearchingUsersState());
    //   usersList = UserRepository.usersList
    //       .where(
    //         (element) => element.mobileNumber!
    //             .toLowerCase()
    //             .contains(event.mobileNumber.toLowerCase()),
    //       )
    //       .toList();

    //   emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 2));
    // });
    // on<SearchUserByStreetEvent>((event, emit) {
    //   emit(SearchingUsersState());
    //   usersList = UserRepository.usersList
    //       .where(
    //         (element) => element.streetName!
    //             .toLowerCase()
    //             .contains(event.streetName.toLowerCase()),
    //       )
    //       .toList();
    //   emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 3));
    // });
  }
}
