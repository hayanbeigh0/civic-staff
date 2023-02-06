import 'dart:convert';

import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:flutter/services.dart';

class GrievancesRepository {
  List<Grievances> grievanceList = [];
  Future<String> getGrievancesJson() async {
    return rootBundle.loadString('assets/grievance.json');
  }

  Future<List<Grievances>> loadGrievancesJson() async {
    await Future.delayed(const Duration(seconds: 2));
    final list = json.decode(await getGrievancesJson()) as List<dynamic>;
    grievanceList = list.map((e) => Grievances.fromJson(e)).toList();
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

  Future<Grievances> updateGrievanceStatus(
      String grievanceId, String status) async {
    Grievances grievance = grievanceList
        .firstWhere((element) => element.grievanceId == grievanceId);
    grievance.status = status;
    return grievance;
  }
}
