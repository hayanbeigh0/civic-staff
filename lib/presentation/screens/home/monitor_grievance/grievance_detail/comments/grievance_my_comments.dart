import 'package:civic_staff/models/grievances/grievances_model.dart';
import 'package:flutter/material.dart';

class GrievanceMyComments extends StatelessWidget {
  static const routeName = '/grievanceMyComments';
  final List<MyComments> myComments;
  const GrievanceMyComments({
    super.key,
    required this.myComments,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
