import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/constants/env_variable.dart';
import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class GrievancesRepository {
  // static List<Grievances> grievanceList = [];
  Future<String> getGrievancesJson() async {
    final response = await Dio().get(
      '$API_URL/grievances/all-grievances',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    // log(jsonEncode(response.data));
    return jsonEncode(response.data);
  }

  Future<List<Grievances>> loadGrievancesJson() async {
    List<Grievances> grievanceList = [];
    try {
      final list = json.decode(await getGrievancesJson()) as List<dynamic>;
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

  // Future<List<Grievances>> closeGrievance(String grievanceId) async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   grievanceList
  //           .firstWhere((element) => element.grievanceID == grievanceId)
  //           .open ==
  //       false;

  //   return grievanceList;
  // }

  updateGrievanceStatus(String grievanceId, Grievances newGrievance) async {
    List<Grievances> grievanceList = [];
    final grievanceIndex = grievanceList
        .indexWhere((element) => element.grievanceID == grievanceId);
    grievanceList[grievanceIndex] = newGrievance;
    log('new expected completion: ${grievanceList[grievanceIndex].expectedCompletion}');
  }

  updateExpectedCompletion(
      String grievanceId, String expectedCompletion) async {}
}
