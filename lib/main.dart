import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/logic/cubits/home_grid_items/home_grid_items_cubit.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/resources/repositories/Users/user_repository.dart';
import 'package:civic_staff/resources/repositories/my_profile/my_profile.dart';

import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/presentation/screens/login/login.dart';
import 'package:civic_staff/resources/repositories/grievances/grievances_repository.dart';
import 'package:civic_staff/presentation/router/app_router.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<GrievancesBloc>(
              create: (context) => GrievancesBloc(GrievancesRepository()),
            ),
            BlocProvider<ReverseGeocodingCubit>(
              create: (context) => ReverseGeocodingCubit(),
            ),
            BlocProvider<CurrentLocationCubit>(
              create: (context) => CurrentLocationCubit(),
            ),
            BlocProvider<UsersBloc>(
              create: (context) => UsersBloc(UserRepository())
                ..add(
                  const LoadUsersEvent(1),
                ),
            ),
            BlocProvider<MyProfileCubit>(
              create: (context) =>
                  MyProfileCubit(MyProfileRerpository())..getMyProfile(),
            ),
            BlocProvider<HomeGridItemsCubit>(
              create: (context) => HomeGridItemsCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Staff App',
            theme: ThemeData(
              fontFamily: 'LexendDeca',
              useMaterial3: true,
              primaryColor: AppColors.colorPrimary,
            ),
            home: Login(),
            onGenerateRoute: (settings) => AppRouter.onGenrateRoute(settings),
          ),
        );
      },
    );
  }
}
