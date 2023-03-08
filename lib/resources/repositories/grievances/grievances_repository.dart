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

  Future<void> addGrievanceCommentFile({
    required File commentFile,
  }) async {
    try {
      // final response = await AwsS3.uploadFile(
      //   accessKey: "AKIAY34HZENYIHMRUOMP",
      //   secretKey: "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",
      //   file: commentFile,
      //   bucket: "dev-civic",
      //   region: "ap-south-1",
      // );
      // returns url pointing to S3 file

      SimpleS3 _simpleS3 = SimpleS3();
      String response = await _simpleS3.uploadFile(
        commentFile,
        "dev-civic",
        'ap-south-1_KZfVLAj1B',
        AWSRegions.apSouth1,
        s3FolderPath: "grievance",
        debugLog: true,
      );
      log(response.toString());
    } catch (e) {
      log(e.toString());
    }
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
