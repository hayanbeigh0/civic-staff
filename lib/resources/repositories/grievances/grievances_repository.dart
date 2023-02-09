import 'dart:convert';
import 'dart:developer';

import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:flutter/services.dart';

class GrievancesRepository {
  static List<Grievances> grievanceList = [];
  Future<String> getGrievancesJson() async {
    return rootBundle.loadString('assets/grievance.json');
  }

  Future<List<Grievances>> loadGrievancesJson() async {
    await Future.delayed(const Duration(seconds: 2));
    final list = json.decode(await getGrievancesJson()) as List<dynamic>;
    grievanceList = list.map((e) => Grievances.fromJson(e)).toList();
    log('Loaded grievances!');
    // grievanceList.sort((g1, g2) {
    //   DateTime timestamp1 = DateTime.parse(g1.timeStamp.toString());
    //   DateTime timestamp2 = DateTime.parse(g2.timeStamp.toString());
    //   return timestamp2.compareTo(timestamp1);
    // });
    return grievanceList;
  }

  Future<List<Grievances>> closeGrievance(String grievanceId) async {
    await Future.delayed(const Duration(seconds: 2));
    grievanceList
            .firstWhere((element) => element.grievanceId == grievanceId)
            .open ==
        false;

    return grievanceList;
  }

  updateGrievanceStatus(String grievanceId, String status) async {
    grievanceList
        .firstWhere((element) => element.grievanceId == grievanceId)
        .status = status;
  }

  updateExpectedCompletion(
      String grievanceId, String expectedCompletion) async {
    grievanceList
        .firstWhere((element) => element.grievanceId == grievanceId)
        .expectedCompletion = expectedCompletion;
  }
}
