import 'package:civic_staff/logic/cubits/authentication/authentication_cubit.dart';
import 'package:civic_staff/logic/cubits/local_storage/local_storage_cubit.dart';
import 'package:civic_staff/models/user_details.dart';
import 'package:civic_staff/presentation/screens/home/home.dart';
import 'package:civic_staff/resources/repositories/auth/authentication_repository.dart';
import 'package:flutter/material.dart';

import 'package:civic_staff/presentation/screens/login/login.dart';
import 'package:civic_staff/logic/blocs/grievances/grievances_bloc.dart';
import 'package:civic_staff/logic/blocs/users_bloc/users_bloc.dart';
import 'package:civic_staff/logic/cubits/current_location/current_location_cubit.dart';
import 'package:civic_staff/logic/cubits/home_grid_items/home_grid_items_cubit.dart';
import 'package:civic_staff/logic/cubits/my_profile/my_profile_cubit.dart';
import 'package:civic_staff/logic/cubits/reverse_geocoding/reverse_geocoding_cubit.dart';
import 'package:civic_staff/presentation/router/app_router.dart';
import 'package:civic_staff/presentation/utils/colors/app_colors.dart';
import 'package:civic_staff/resources/repositories/Users/user_repository.dart';
import 'package:civic_staff/resources/repositories/grievances/grievances_repository.dart';
import 'package:civic_staff/resources/repositories/my_profile/my_profile.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late Locale locale;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Future.delayed(const Duration(seconds: 2));
  locale = WidgetsBinding.instance.window.locales.first;
  FlutterNativeSplash.remove();
  runApp(
    EasyLocalization(
      path: 'assets/i18n',
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      startLocale: Locale(locale.languageCode),
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    locale = WidgetsBinding.instance.window.locales.first;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    setState(() {
      context.setLocale(Locale(locales!.first.languageCode));
    });
    super.didChangeLocales(locales);
  }

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
              create: (context) => MyProfileCubit(MyProfileRerpository()),
            ),
            BlocProvider<HomeGridItemsCubit>(
              create: (context) => HomeGridItemsCubit(),
            ),
            BlocProvider<AuthenticationCubit>(
              create: (context) => AuthenticationCubit(
                AuthenticationRepository(),
              ),
            ),
            BlocProvider<LocalStorageCubit>(
              create: (context) => LocalStorageCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Staff App',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              fontFamily: 'LexendDeca',
              useMaterial3: true,
              primaryColor: AppColors.colorPrimary,
            ),
            home: const AuthBasedRouting(),
            onGenerateRoute: (settings) => AppRouter.onGenrateRoute(settings),
          ),
        );
      },
    );
  }
}

class AuthBasedRouting extends StatelessWidget {
  const AuthBasedRouting({
    Key? key,
  }) : super(key: key);

  static late AfterLogin afterLogin;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LocalStorageCubit>(context).getUserDataFromLocalStorage();
    return BlocBuilder<LocalStorageCubit, LocalStorageState>(
      builder: (context, state) {
        if (state is LocalStorageFetchingDoneState) {
          afterLogin = state.afterLogin;
          return HomeScreen();
        }
        if (state is LocalStorageUserNotPresentState) {
          return Login();
        }
        if (state is LocalStorageFetchingFailedState) {
          return Login();
        }
        return const SizedBox();
        // return const Scaffold(
        //   backgroundColor: AppColors.colorWhite,
        //   body: Center(
        //     child: RepaintBoundary(
        //       child: CircularProgressIndicator(
        //         color: AppColors.colorPrimary,
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
