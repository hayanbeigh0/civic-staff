import 'package:bloc/bloc.dart';
import 'package:civic_staff/models/grid_tile_model.dart';
import 'package:civic_staff/presentation/screens/home/enroll_user/enroll_user.dart';
import 'package:civic_staff/presentation/screens/home/monitor_grievance/grievance_list.dart';
import 'package:civic_staff/presentation/screens/home/profile/profile.dart';
import 'package:civic_staff/presentation/screens/home/search_user/search_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

part 'home_grid_items_state.dart';

class HomeGridItemsCubit extends Cubit<HomeGridItemsState> {
  final List<HomeGridTile> gridItems = [
    HomeGridTile(
      routeName: EnrollUser.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3.5,
        child: SvgPicture.asset('assets/svg/enrolluser.svg'),
      ),
      gridTileTitle: 'Enroll User',
    ),
    HomeGridTile(
      routeName: GrievanceList.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/monitorgrievances.svg'),
      ),
      gridTileTitle: 'Monitor Grievances',
    ),
    HomeGridTile(
      routeName: SearchUser.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3.5,
        child: SvgPicture.asset('assets/svg/search.svg'),
      ),
      gridTileTitle: 'Search User',
    ),
    HomeGridTile(
      routeName: ProfileScreen.routeName,
      gridIcon: AspectRatio(
        aspectRatio: 3,
        child: SvgPicture.asset('assets/svg/profile.svg'),
      ),
      gridTileTitle: 'Profile',
    ),
  ];
  HomeGridItemsCubit() : super(HomeGridItemsLoading());
  loadSearchedGridItems(String title, bool searching) {
    emit(HomeGridItemsLoading());
    if (searching) {
      final List<HomeGridTile> sortedList = gridItems
          .where((element) =>
              element.gridTileTitle.toLowerCase().toString().contains(title))
          .toList();

      emit(HomeGridItemsLoaded(gridItems: sortedList));
    } else {
      emit(HomeGridItemsLoaded(gridItems: gridItems));
    }
  }

  loadAllGridItems() {
    emit(HomeGridItemsLoading());

    emit(HomeGridItemsLoaded(gridItems: gridItems));
  }
}
