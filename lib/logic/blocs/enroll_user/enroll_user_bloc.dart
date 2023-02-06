import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'enroll_user_event.dart';
part 'enroll_user_state.dart';

class EnrollUserBloc extends Bloc<EnrollUserEvent, EnrollUserState> {
  EnrollUserBloc() : super(EnrollUserInitial()) {
    on<EnrollUserEvent>((event, emit) {});
  }
}
