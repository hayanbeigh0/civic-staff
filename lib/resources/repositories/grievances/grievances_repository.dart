import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/grievances/grievances_model.dart';

class GrievancesRepository {
  // static List<Grievances> grievanceList = [];
  Future<String> getGrievancesJson(
      String municipalityId, String staffId) async {
    final response = await Dio()
        .get(
          '$API_URL/staff/allotted-grievances',
          data: jsonEncode(
              {"MunicipalityID": municipalityId, "StaffID": staffId}),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );
    return jsonEncode(response.data);
  }

  Future<List<Grievances>> loadGrievancesJson(
      String municipalityId, String staffId) async {
    List<Grievances> grievanceList = [];
    try {
      final list = json.decode(await getGrievancesJson(municipalityId, staffId))
          as List<dynamic>;
      grievanceList = list.map((e) => Grievances.fromJson(e)).toList();
      grievanceList.sort((g1, g2) {
        DateTime timestamp1 = DateTime.parse(g1.lastModifiedDate.toString());
        DateTime timestamp2 = DateTime.parse(g2.lastModifiedDate.toString());
        return timestamp2.compareTo(timestamp1);
      });
    } catch (e) {
      print(e.toString());
    }
    return grievanceList;
  }

  Future<Response> addGrievanceCommentFile({
    required String encodedCommentFile,
    required String fileType,
    required String grievanceId,
  }) async {
    // log('S3 request payload: ${jsonEncode({
    //       "File": encodedCommentFile,
    //       "FileType": fileType,
    //       "GrievanceID": grievanceId,
    //       "Section": 'comments'
    //     })}');
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
    } catch (e) {
      print(e.toString());
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

    return response;
  }

  Future<Response> modifyGrievance(
      String grievanceId, Grievances newGrievance) async {
        print("In post modify-grievance function");
    final response = await Dio().post(
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
    print("Response from post method: ${response.data}");
    return response;
  }

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
