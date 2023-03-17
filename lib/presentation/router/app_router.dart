import 'package:civic_staff/presentation/screens/home/enroll_user/edit_user.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/screens/login/activation_screen.dart';
import 'package:civic_staff/presentation/screens/login/login.dart';
import 'package:civic_staff/presentation/screens/home/enroll_user/enroll_user.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_audio.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_detail.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_map.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/grievance_photo_video.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_detail/comments/grievance_comments.dart';
import 'package:civic_staff/presentation/screens/home/profile/edit_profile.dart';
import 'package:civic_staff/presentation/screens/home/profile/profile.dart';
import 'package:civic_staff/presentation/screens/home/search_user/search_user.dart';
import 'package:civic_staff/presentation/screens/home/search_user/user_details.dart';
import 'package:civic_staff/presentation/screens/home/home.dart';

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
            userDetails: args['userDetails'],
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
          builder: (context) => GrievanceMap(),
        );
      case GrievanceDetail.routeName:
        return MaterialPageRoute(
          builder: (context) => GrievanceDetail(
            // state: args['state'],
            // grievanceListIndex: args['index'],
            grievanceId: args['grievanceId'],
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
      case AllComments.routeName:
        return MaterialPageRoute(
          builder: (context) => AllComments(
            grievanceId: args['grievanceId'],
          ),
        );
      case EnrollUser.routeName:
        return MaterialPageRoute(
          builder: (context) => const EnrollUser(),
        );
      case SearchUser.routeName:
        return PageRouteBuilder(
          barrierColor: Colors.black54,
          barrierDismissible: true,
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => const SearchUser(),
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
      case UserDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => UserDetails(
            user: args['user'],
          ),
        );
      case ProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );
      case EditProfileScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditProfileScreen(
            myProfile: args['my_profile'],
          ),
        );
      case EditUserScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditUserScreen(
            user: args['user'],
          ),
        );
      default:
        return null;
    }
  }
}
