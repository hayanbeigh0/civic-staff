// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_grid_items_cubit.dart';

abstract class HomeGridItemsState extends Equatable {
  const HomeGridItemsState();
}

class HomeGridItemsLoading extends HomeGridItemsState {
  @override
  List<Object?> get props => [];
}

class HomeGridItemsLoaded extends HomeGridItemsState {
  final List<HomeGridTile> gridItems;
  const HomeGridItemsLoaded({
    required this.gridItems,
  });

  @override
  List<Object?> get props => [gridItems];
}
