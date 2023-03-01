import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:civic_staff/resources/repositories/grievances/grievances_repository.dart';
import 'package:equatable/equatable.dart';

part 'grievances_event.dart';
part 'grievances_state.dart';

class GrievancesBloc extends Bloc<GrievancesEvent, GrievancesState> {
  final GrievancesRepository grievancesRepository;
  GrievancesBloc(this.grievancesRepository) : super(GrievancesLoadingState()) {
    on<GrievancesEvent>((event, emit) {});

    on<LoadGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      try {
        List<Grievances> updatedGrievanceList =
            await grievancesRepository.loadGrievancesJson();
        updatedGrievanceList.sort((g1, g2) {
          DateTime timestamp1 = DateTime.parse(g1.lastModifiedDate.toString());
          DateTime timestamp2 = DateTime.parse(g2.lastModifiedDate.toString());
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
      // await grievancesRepository.closeGrievance(event.grievanceId);
      emit(GrievanceClosedState());
      add(LoadGrievancesEvent());
    });

    on<UpdateGrievanceEvent>((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      await grievancesRepository.updateGrievanceStatus(
        event.grievanceId,
        event.newGrievance,
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
    on<SearchGrievanceByTypeEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      // userRepository.loadUserJson();
      List<Grievances> updatedGrievanceList =
          await grievancesRepository.loadGrievancesJson();
      updatedGrievanceList = updatedGrievanceList
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
      if (updatedGrievanceList.isEmpty) {
        emit(NoGrievanceFoundState());
      } else {
        emit(
          GrievancesLoadedState(
            grievanceList: updatedGrievanceList,
            selectedFilterNumber: 1,
          ),
        );
      }
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
