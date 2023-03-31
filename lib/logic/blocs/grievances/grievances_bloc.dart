import 'dart:developer';

import 'package:civic_staff/main.dart';
import 'package:civic_staff/models/grievances/grievance_detail_model.dart';
import 'package:civic_staff/models/s3_upload_result.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
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
    final Map<String, String> grievanceTypesMap = {
      "garb": 'Garbage Collection',
      "road": 'Road maintenance / Construction',
      "light": 'Street Lighting',
      "cert": 'Certificate Request',
      "house": 'House plan approval',
      "water": 'Water supply / drainage',
      "elect": 'Electricity',
      "other": 'Other',
    };
    on<GrievancesEvent>((event, emit) {});

    on<LoadGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      if (ShowOnlyOpenSwitchState.showOnlyOpen) {
        add(ShowOnlyOpenGrievancesEvent());
      } else {
        try {
          List<Grievances> updatedGrievanceList = await grievancesRepository
              .loadGrievancesJson(event.municipalityId, event.staffId);
          updatedGrievanceList.sort((g1, g2) {
            DateTime timestamp1 =
                DateTime.parse(g1.lastModifiedDate.toString());
            DateTime timestamp2 =
                DateTime.parse(g2.lastModifiedDate.toString());
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
      }
    });

    on<CloseGrievanceEvent>((event, emit) async {
      emit(ClosingGrievanceState());
      // await grievancesRepository.closeGrievance(event.grievanceId);
      emit(GrievanceClosedState());
      add(
        LoadGrievancesEvent(
            staffId: AuthBasedRouting.afterLogin.userDetails!.staffID!,
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
      } on DioError catch (e) {
        log('Grievance loading failed');
        emit(LoadingGrievanceByIdFailedState());
      }
    });

    on<UpdateGrievanceStatusEvent>(((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      try {
        final response = await grievancesRepository.modifyGrievance(
            event.grievanceId, event.newGrievance);
        if (response.statusCode == 200) {
          emit(const GrievanceUpdatedState(grievanceUpdated: true));
        } else {
          emit(UpdatingGrievanceStatusFailedState());
        }
        add(GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.municipalityId));
      } on DioError catch (e) {
        emit(UpdatingGrievanceStatusFailedState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.grievanceId,
          ),
        );
      }
    }));

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
        emit(UpdatingGrievanceStatusFailedState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.grievanceId,
          ),
        );
      }
    });
    on<UpdateGrievanceTypeEvent>((event, emit) async {
      emit(UpdatingGrievanceStatusState());
      try {
        final response = await grievancesRepository.modifyGrieance(
          event.grievanceId,
          event.newGrievance,
        );
        if (response.statusCode == 200) {
          emit(const GrievanceUpdatedState(grievanceUpdated: true));
          emit(GrievanceTypeUpdatedState());
        } else {
          emit(UpdatingGrievanceStatusFailedState());
        }
      } on DioError catch (e) {
        emit(UpdatingGrievanceStatusFailedState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: event.municipalityId,
            grievanceId: event.grievanceId,
          ),
        );
      }
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
        emit(AddingGrievanceCommentSuccessState());
        add(
          GetGrievanceByIdEvent(
            municipalityId: AuthBasedRouting
                .afterLogin.userDetails!.municipalityID
                .toString(),
            grievanceId: event.grievanceId,
          ),
        );
      } on DioError catch (e) {
        emit(AddingGrievanceCommentFailedState());
      }
    });
    on<AddGrievanceAudioCommentAssetsEvent>((event, emit) async {
      emit(AddingGrievanceAudioCommentAssetState());
      try {
        final response = await grievancesRepository.addGrievanceCommentFile(
          grievanceId: event.grievanceId,
          encodedCommentFile: event.encodedCommentFile,
          fileType: event.fileType,
        );
        S3UploadResult s3uploadResult = S3UploadResult.fromJson(response.data);
        emit(AddingGrievanceAudioCommentAssetSuccessState(
          s3uploadResult: s3uploadResult,
        ));
      } on DioError catch (e) {
        emit(AddingGrievanceAudioCommentAssetFailedState());
      }
    });
    on<AddGrievanceImageCommentAssetsEvent>((event, emit) async {
      emit(AddingGrievanceImageCommentAssetState());
      try {
        final response = await grievancesRepository.addGrievanceCommentFile(
          grievanceId: event.grievanceId,
          encodedCommentFile: event.encodedCommentFile,
          fileType: event.fileType,
        );
        S3UploadResult s3uploadResult = S3UploadResult.fromJson(response.data);
        emit(AddingGrievanceImageCommentAssetSuccessState(
          s3uploadResult: s3uploadResult,
        ));
      } on DioError catch (e) {
        emit(AddingGrievanceImageCommentAssetFailedState());
      }
    });
    on<AddGrievanceVideoCommentAssetsEvent>((event, emit) async {
      emit(AddingGrievanceVideoCommentAssetState());
      try {
        final response = await grievancesRepository.addGrievanceCommentFile(
          grievanceId: event.grievanceId,
          encodedCommentFile: event.encodedCommentFile,
          fileType: event.fileType,
        );
        S3UploadResult s3uploadResult = S3UploadResult.fromJson(response.data);
        emit(AddingGrievanceVideoCommentAssetSuccessState(
          s3uploadResult: s3uploadResult,
        ));
      } on DioError catch (e) {
        log(e.error.toString());
        emit(AddingGrievanceVideoCommentAssetFailedState());
      }
    });
    on<SearchGrievanceByReporterNameEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      // userRepository.loadUserJson();
      List<Grievances> updatedGrievanceList =
          await grievancesRepository.loadGrievancesJson(
        AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
        AuthBasedRouting.afterLogin.userDetails!.staffID!,
      );
      updatedGrievanceList = updatedGrievanceList
          .where(
            (element) => element.createdByName!
                .toLowerCase()
                .toLowerCase()
                .replaceAll(' ', '')
                .startsWith(
                  event.reporterName.toLowerCase().replaceAll(' ', ''),
                ),
          )
          .toList();

      updatedGrievanceList.sort(
        (a, b) => DateTime.parse(a.lastModifiedDate.toString())
            .compareTo(DateTime.parse(b.lastModifiedDate.toString())),
      );
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
    on<ShowOnlyOpenGrievancesEvent>((event, emit) async {
      emit(GrievancesLoadingState());
      List<Grievances> updatedGrievanceList =
          await grievancesRepository.loadGrievancesJson(
              AuthBasedRouting.afterLogin.userDetails!.municipalityID!,
              AuthBasedRouting.afterLogin.userDetails!.staffID!);
      print("UpdatedGrievanceList: ${updatedGrievanceList}");
      updatedGrievanceList = updatedGrievanceList
          .where((element) => element.status != '2')
          .toList();

      // updatedGrievanceList.sort();
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
