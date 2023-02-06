import 'package:civic_staff/presentation/screens/home/enroll_user/enroll_user.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_add_comment.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_audio.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_map.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_my_comments.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_photo_video.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_reporter_comments.dart';
import 'package:civic_staff/presentation/screens/home/search_user/search_user.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/screens/login/activation_screen.dart';
import 'package:civic_staff/presentation/screens/home/home.dart';
import 'package:civic_staff/presentation/screens/login/login.dart';

class AppRouter {
  static Route? onGenrateRoute(RouteSettings routeSettings) {
    final Map<String, dynamic> args = routeSettings.arguments == null
        ? {}
        : routeSettings.arguments as Map<String, dynamic>;
    switch (routeSettings.name) {
      case Login.routeName:
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case Activation.routeName:
        return MaterialPageRoute(
          builder: (context) => Activation(
            mobileNumber: args['mobileNumber'],
          ),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case GrievanceList.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceList(),
        );
      case GrievanceMap.routeName:
        return MaterialPageRoute(
          builder: (context) => const GrievanceMap(),
        );
      case GrievanceDetail.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceDetail(
            state: args['state'],
            grievanceListIndex: args['index'],
          ),
        );
      case GrievancePhotoVideo.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievancePhotoVideo(
            grievanceListIndex: args['index'],
            state: args['state'],
          ),
        );
      case GrievanceAudio.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceAudio(
            grievanceListIndex: args['index'],
            state: args['state'],
          ),
        );
      case GrievanceReporterComments.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceReporterComments(
            reporterComments: args['reporterComments'],
          ),
        );
      case GrievanceMyComments.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceMyComments(
            myComments: args['myComments'],
          ),
        );
      case GrievanceAddComment.routeName:
        return MaterialPageRoute(
          builder: (context) => const GrievanceAddComment(),
        );
      case EnrollUser.routeName:
        return MaterialPageRoute(
          builder: (context) => EnrollUser(),
        );
      case SearchUser.routeName:
        return PageRouteBuilder(
          barrierColor: Colors.black54,
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => SearchUser(),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      // return MaterialPageRoute(
      //   builder: (context) => SearchUser(),
      // );
      default:
        return null;
    }
  }
}
