// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'grievances_bloc.dart';

abstract class GrievancesEvent extends Equatable {
  const GrievancesEvent();
}

class LoadGrievancesEvent extends GrievancesEvent {
  final String municipalityId;
  const LoadGrievancesEvent({
    required this.municipalityId,
  });
  @override
  List<Object> get props => [municipalityId];
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
  final String municipalityId;
  const UpdateGrievanceEvent({
    required this.grievanceId,
    required this.newGrievance,
    required this.municipalityId,
  });
  @override
  List<Object> get props => [grievanceId, newGrievance];
}

class UpdateGrievanceTypeEvent extends GrievancesEvent {
  final Grievances newGrievance;
  final String grievanceId;
  final String municipalityId;
  const UpdateGrievanceTypeEvent({
    required this.grievanceId,
    required this.newGrievance,
    required this.municipalityId,
  });
  @override
  List<Object> get props => [grievanceId, newGrievance, municipalityId];
}

class AddGrievanceCommentEvent extends GrievancesEvent {
  final String grievanceId;
  final String staffId;
  final String name;
  final String comment;
  final Map assets;
  const AddGrievanceCommentEvent(
      {required this.grievanceId,
      required this.staffId,
      required this.name,
      required this.assets,
      required this.comment});
  @override
  List<Object> get props => [grievanceId, staffId, name, assets, comment];
}

class AddGrievanceAudioCommentAssetsEvent extends GrievancesEvent {
  final String encodedCommentFile;
  final String fileType;
  final String grievanceId;
  const AddGrievanceAudioCommentAssetsEvent({
    required this.grievanceId,
    required this.fileType,
    required this.encodedCommentFile,
  });
  @override
  List<Object> get props => [grievanceId, fileType, encodedCommentFile];
}

class AddGrievanceImageCommentAssetsEvent extends GrievancesEvent {
  final String encodedCommentFile;
  final String fileType;
  final String grievanceId;
  const AddGrievanceImageCommentAssetsEvent({
    required this.grievanceId,
    required this.fileType,
    required this.encodedCommentFile,
  });
  @override
  List<Object> get props => [grievanceId, fileType, encodedCommentFile];
}

class AddGrievanceVideoCommentAssetsEvent extends GrievancesEvent {
  final String encodedCommentFile;
  final String fileType;
  final String grievanceId;
  const AddGrievanceVideoCommentAssetsEvent({
    required this.grievanceId,
    required this.fileType,
    required this.encodedCommentFile,
  });
  @override
  List<Object> get props => [grievanceId, fileType, encodedCommentFile];
}

class GetGrievanceByIdEvent extends GrievancesEvent {
  final String municipalityId;
  final String grievanceId;
  const GetGrievanceByIdEvent({
    required this.municipalityId,
    required this.grievanceId,
  });
  @override
  List<Object> get props => [municipalityId, grievanceId];
}
