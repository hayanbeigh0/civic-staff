import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:flutter/material.dart';

class GrievanceReporterComments extends StatelessWidget {
  final List<ReporterComments> reporterComments;
  static const routeName = '/grievanceReporterComments';
  const GrievanceReporterComments({
    super.key,
    required this.reporterComments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
