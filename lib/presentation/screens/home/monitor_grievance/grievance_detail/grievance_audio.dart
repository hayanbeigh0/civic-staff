import 'package:flutter/material.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';

class GrievanceAudio extends StatelessWidget {
  static const routeName = '/grievanceAudio';
  const GrievanceAudio({
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
