import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:flutter/material.dart';

class GrievancePhotoVideo extends StatelessWidget {
  static const routeName = '/grievancePhotoVideo';
  const GrievancePhotoVideo({
    super.key,
    required this.state,
    required this.grievanceListIndex,
  });
  final GrievancesLoadedState state;
  final int grievanceListIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
