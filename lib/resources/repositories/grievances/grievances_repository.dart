import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:dio/dio.dart';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:simple_s3/simple_s3.dart';

class GrievancesRepository {
  // static List<Grievances> grievanceList = [];
  Future<String> getGrievancesJson(String municipalityId) async {
    final response = await Dio()
        .get(
          '$API_URL/grievances/all-grievances',
          data: jsonEncode({"municipalityId": municipalityId}),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );
    // log(jsonEncode(response.data));
    return jsonEncode(response.data);
  }

  Future<List<Grievances>> loadGrievancesJson(String municipalityId) async {
    List<Grievances> grievanceList = [];
    try {
      final list =
          json.decode(await getGrievancesJson(municipalityId)) as List<dynamic>;
      grievanceList = list.map((e) => Grievances.fromJson(e)).toList();
      grievanceList.sort((g1, g2) {
        DateTime timestamp1 = DateTime.parse(g1.lastModifiedDate.toString());
        DateTime timestamp2 = DateTime.parse(g2.lastModifiedDate.toString());
        return timestamp2.compareTo(timestamp1);
      });
    } catch (e) {
      log(e.toString());
    }
    return grievanceList;
  }

  Future<Response> addGrievanceCommentFile({
    required String encodedCommentFile,
    required String fileType,
    required String grievanceId,
  }) async {
    final response = await Dio().post(
      '$API_URL/general/upload-assets',
      data: jsonEncode({
        "File": encodedCommentFile,
        "FileType": fileType,
        "GrievanceID": grievanceId,
        "Section": 'comments'
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    log(response.data.toString());
    return response;
  }

  Future<void> addGrievanceComment({
    required String grievanceId,
    required String staffId,
    required String name,
    required String comment,
    required Map? assets,
  }) async {
    try {
      final response = Dio().post(
        '$API_URL/grievances/grievance-comments',
        data: jsonEncode(
          {
            "GrievanceID": grievanceId,
            "CommentedBy": staffId,
            "CommentedByName": name,
            "Assets": assets,
            "Comment": comment,
            "CreatedDate": DateTime.now().toString(),
          },
        ),
      );
      log(response.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Response> getGrievanceById({
    required String municipalityId,
    required String grievanceId,
  }) async {
    final response = await Dio().get(
      '$API_URL/grievances/grievance-comments',
      data: jsonEncode({
        "MunicipalityID": municipalityId,
        "GrievanceID": grievanceId,
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    log(response.toString());
    return response;
  }

  // Future<List<Grievances>> closeGrievance(String grievanceId) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   grievanceList
  //           .firstWhere((element) => element.grievanceID == grievanceId)
  //           .open ==
  //       false;

  //   return grievanceList;
  // }

  Future<Response> modifyGrieance(
      String grievanceId, Grievances newGrievance) async {
    final response = await Dio().put(
      '$API_URL/grievances/modify-grievance',
      data: jsonEncode({
        "grievanceId": newGrievance.grievanceID,
        "expectedCompletion": newGrievance.expectedCompletion,
        "municipalityId": newGrievance.municipalityID,
        "userId": newGrievance.createdBy,
        "createdByName": newGrievance.createdByName,
        "grievanceType": newGrievance.grievanceType,
        "priority": newGrievance.priority,
        "status": newGrievance.status,
        "wardNumber": newGrievance.wardNumber,
        "description": newGrievance.description,
        "contactNumber": newGrievance.contactNumber,
        "latitude": newGrievance.locationLat,
        "longitude": newGrievance.locationLong,
        "address": newGrievance.address,
        "contactByPhoneEnabled": newGrievance.mobileContactStatus,
        "lastModifiedDate": newGrievance.lastModifiedDate,
        "location": newGrievance.location,
        "assets": newGrievance.assets
      }),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return response;
  }

  updateExpectedCompletion(
      String grievanceId, String expectedCompletion) async {}
}
