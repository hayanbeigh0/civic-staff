import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:dio/dio.dart';
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
            await grievancesRepository.loadGrievancesJson(event.municipalityId);
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
        emit(NoGrievanceFoundState());
      }
    });

    on<CloseGrievanceEvent>((event, emit) async {
      emit(ClosingGrievanceState());
      // await grievancesRepository.closeGrievance(event.grievanceId);
      emit(GrievanceClosedState());
      add(
        LoadGrievancesEvent(
            municipalityId:
                AuthBasedRouting.afterLogin.userDetails!.municipalityID!),
      );
    });
    on<GetGrievanceByIdEvent>((event, emit) async {
      emit(LoadingGrievanceByIdState());
      try {
        final response = await grievancesRepository.getGrievanceById(
          grievanceId: event.grievanceId,
          municipalityId: event.municipalityId,
        );
        emit(
          GrievanceByIdLoadedState(
            grievanceDetail: GrievanceDetail.fromJson(
              response.data,
            ),
          ),
        );
        // add(LoadGrievancesEvent(municipalityId: event.municipalityId));
        log('Grievance by Id: ${response.data}');
      } on DioError catch (e) {
        emit(LoadingGrievanceByIdFailedState());
      }
    });

    on<UpdateGrievanceEvent>((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      try {
        final response = await grievancesRepository.modifyGrieance(
          event.grievanceId,
          event.newGrievance,
        );
        if (response.statusCode == 200) {
          emit(const GrievanceUpdatedState(grievanceUpdated: true));
        } else {
          emit(UpdatingGrievanceStatusFailedState());
        }
        add(
          GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.grievanceId,
          ),
        );
      } on DioError catch (e) {
        log('Updating grievane failed: ${e.response}');
        emit(UpdatingGrievanceStatusFailedState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.grievanceId,
          ),
        );
      }
    });
    on<UpdateExpectedCompletionEvent>((event, emit) async {
      emit(UpdatingExpectedCompletionState());
      await grievancesRepository.updateExpectedCompletion(
        event.grievanceId,
        event.expectedCompletion,
      );
      emit(const GrievanceUpdatedState(grievanceUpdated: true));
      add(
        LoadGrievancesEvent(
          municipalityId:
              AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
        ),
      );
    });
    on<AddGrievanceCommentEvent>((event, emit) async {
      emit(AddingGrievanceCommentState());
      try {
        await grievancesRepository.addGrievanceComment(
          grievanceId: event.grievanceId,
          assets: event.assets == {} ? null : event.assets,
          name: event.name,
          staffId: event.staffId,
          comment: event.comment,
        );
        // emit(const GrievanceUpdatedState(grievanceUpdated: true));
        // add(
        //   LoadGrievancesEvent(
        //     municipalityId:
        //         AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
        //   ),
        // );
        emit(AddingGrievanceCommentSuccessState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: AuthBasedRouting
                .afterLogin.userDetails!.municipalityID
                .toString(),
            grievanceId: event.grievanceId,
          ),
        );
        log('Successfully added a comment!');
      } on DioError catch (e) {
        log('Adding comment failed: ${e.message}');
        emit(AddingGrievanceCommentFailedState());
      }
    });
    on<SearchGrievanceByTypeEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      // userRepository.loadUserJson();
      List<Grievances> updatedGrievanceList =
          await grievancesRepository.loadGrievancesJson(
              AuthBasedRouting.afterLogin.userDetails!.municipalityID!);
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
  }
}
