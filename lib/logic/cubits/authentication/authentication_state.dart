// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class OtpSentSucessfully extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoginErrorState extends AuthenticationState {
  final String error;
  const AuthenticationLoginErrorState({
    required this.error,
  });
  @override
  List<Object?> get props => [error];
}

class AuthenticationOtpErrorState extends AuthenticationState {
  final String error;
  const AuthenticationOtpErrorState({
    required this.error,
  });
  @override
  List<Object?> get props => [error];
}

class AuthenticationSuccessState extends AuthenticationState {
  AfterLogin afterLogin;
  AuthenticationSuccessState({
    required this.afterLogin,
  });
  @override
  List<Object?> get props => [afterLogin];
}

class OtpSentState extends AuthenticationState {
  final String sessionId;
  final String username;
  final String phoneNumber;
  const OtpSentState({
    required this.sessionId,
    required this.username,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [sessionId, username, phoneNumber];
}

class NavigateToActivationState extends AuthenticationState {
  final String sessionId;
  final String username;
  final String phoneNumber;
  const NavigateToActivationState({
    required this.sessionId,
    required this.username,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [sessionId, username, phoneNumber];
}
