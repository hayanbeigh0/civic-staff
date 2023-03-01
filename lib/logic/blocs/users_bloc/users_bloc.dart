import 'package:bloc/bloc.dart';
import 'package:civic_staff/models/user_model.dart';
import 'package:civic_staff/resources/repositories/Users/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<SearchUsersEvent, SearchUsersState> {
  UserRepository userRepository;
  String selectedFilter = 'name';
  List<User> usersList = [];
  UsersBloc(this.userRepository) : super(SearchingUsersState()) {
    on<LoadUsersEvent>((event, emit) {
      userRepository.loadUserJson();
      emit(SearchingUsersState());
    });

    on<SearchUserByNameEvent>((event, emit) {
      emit(SearchingUsersState());
      // userRepository.loadUserJson();
      usersList = UserRepository.usersList
          .where(
            (element) => element.firstName!
                .toLowerCase()
                .contains(event.name.toLowerCase()),
          )
          .toList();
      emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 1));
    });
    on<SearchUserByMobileEvent>((event, emit) {
      // userRepository.loadUserJson();
      emit(SearchingUsersState());
      usersList = UserRepository.usersList
          .where(
            (element) => element.mobileNumber!
                .toLowerCase()
                .contains(event.mobileNumber.toLowerCase()),
          )
          .toList();

      emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 2));
    });
    on<SearchUserByStreetEvent>((event, emit) {
      emit(SearchingUsersState());
      usersList = UserRepository.usersList
          .where(
            (element) => element.address!.toLowerCase().contains(
                  event.streetName.toLowerCase(),
                ),
          )
          .toList();
      emit(LoadedUsersState(userList: usersList, selectedFilterNumber: 3));
    });
    on<EnrollAUserEvent>((event, emit) async {
      emit(const EnrollingAUserState(loading: true));
      await userRepository.addUser(event.user);
      emit(UserEnrolledState(user: event.user));
    });
    on<EditUserEvent>((event, emit) async {
      emit(const EnrollingAUserState(loading: true));
      await editUser(event.user);
      emit(
        LoadedUsersState(
          selectedFilterNumber: 0,
          userList: usersList,
        ),
      );
      emit(UserEditedState(user: event.user));
    });
  }
  Future<void> editUser(User user) async {
    await Future.delayed(const Duration(seconds: 2));

    User newUser =
        usersList.firstWhere((element) => element.userId == user.userId);
    newUser.about = user.about;
    newUser.address = user.address;
    newUser.mobileNumber = user.mobileNumber;
    newUser.emailId = user.emailId;
    newUser.latitude = user.latitude;
    newUser.longitude = user.longitude;
    newUser.wardNumber = user.wardNumber;
    newUser.firstName = user.firstName;
    newUser.lastName = user.lastName;
  }
}
